# This script is to delete VPCs in all the regions except the skipped ones, for a particular AWS profile.
# Please pass profile name as command-line argument, while running this script:
# > ./delete-vpcs.sh profile_name

#!/bin/bash

# function to check if region is to be skipped
CheckIfRegionIsToBeSkipped () {
  if [ ! -z "${skip_regions}"  ]; then
    for skip_region in ${skip_regions//,/ }; do
      if [ "${skip_region}" = "${1}" ]; then
        return 1
      fi
    done
  fi
  return 0
}

# function to get and delete internet gateway
GetAndDeleteInternetGateway () {
  igw=$(aws ec2 --region ${1} describe-internet-gateways --filter Name=attachment.vpc-id,Values=${2} --profile ${3} | jq -r .InternetGateways[0].InternetGatewayId)
  if [ "${igw}" != "null" ]; then
    echo "Detaching and deleting internet gateway '${igw}'."
    aws ec2 --region ${1} detach-internet-gateway --internet-gateway-id ${igw} --vpc-id ${2} --profile ${3}
    aws ec2 --region ${1} delete-internet-gateway --internet-gateway-id ${igw} --profile ${3}
  fi
}

# function to get and delete subnets
GetAndDeleteSubnets () {
  subnets=$(aws ec2 --region ${1} describe-subnets --filters Name=vpc-id,Values=${2} --profile ${3} | jq -r .Subnets[].SubnetId)
  if [ ! -z "${subnets}" ]; then
    for subnet in ${subnets}; do
      echo "Deleting subnet '${subnet}'."
      aws ec2 --region ${1} delete-subnet --subnet-id ${subnet} --profile ${3}
    done
  fi
}

# function to delete vpc
DeleteVPC () {
  echo "Deleting VPC '${2}'."
  aws ec2 --region ${1} delete-vpc --vpc-id ${2} --profile ${3}
}


# if no command-line argument passed to the script, throw error and exit code
if [ -z "${1}"  ]; then
	echo "Error! No AWS Profile passed." 1>&2
	exit 1
fi

# get from user the regions to be skipped
echo "Do you want to skip the deletion process for few regions ? (Y/N)"
read is_skip_regions
if [ "${is_skip_regions}" = "Y" ]; then
  echo "Please enter the regions. (separated with comma)"
  read skip_regions
fi

i=0
# loop over all the regions
for region in $(aws ec2 describe-regions --region us-east-1 --profile ${1} | jq -r .Regions[].RegionName); do
  # check if current region is to be skipped
  CheckIfRegionIsToBeSkipped ${region}
  if [ "${?}" = 1 ]; then
    echo "Skipping for ${region} region."
    continue
  fi

  # get all the vpcs in the current region
  vpcs=$(aws ec2 --region ${region} describe-vpcs --profile ${1} | jq -r .Vpcs[].VpcId)

  # skip, if no vpc found in the region
  if [ -z "${vpcs}" ]; then
    echo "No VPC found in ${region} region."
    continue
  fi
  
  # loop over the found vpcs
  echo "The following VPC(s) found in ${region} region:"
  for vpc in ${vpcs}; do
    # display vpc
    echo -e "\t> ${vpc}"

    # get ec2 instances associated with vpc, if any
    ec2s=$(aws ec2 --region ${region} describe-instances --filters Name=vpc-id,Values=${vpc} --profile ${1} | jq -r .Reservations[].Instances[].InstanceId)
    if [ ! -z "${ec2s}" ]; then
      echo -e "\t  The following EC2 instance(s) associated with this VPC:"
      # display the associated instances
      for ec2 in ${ec2s}; do
        echo -e "\t  \t> ${ec2}"
      done
      echo -e "\t  Therefore, this VPC can't considered for deletion."
      continue
    fi
    
    # store vpc and it's region for further process, if no instance is associated with the vpc
    vpc_arr[$i]=${vpc}
    region_arr[$i]=${region}
    ((i++))
  done
done

# if VPCs exist without having any associated EC2 instances, then proceed with the deletion process
if [[ ! ( -z ${vpc_arr[0]} || -z ${region_arr[0]} ) ]]; then
  while [ "${i}" -gt 0 ]; do
    ((i--))

    # ask user if vpc is to be deleted
    echo "Do you want to delete the VPC '${vpc_arr[$i]}' in ${region_arr[$i]} region ? (Y/N)"
    read is_delete_vpc

    if [ "${is_delete_vpc}" = "Y" ]; then
      echo "Working on the deletion of VPC '${vpc_arr[$i]}' in ${region_arr[$i]} region."
      
      # get and delete internet gateway
      GetAndDeleteInternetGateway ${region_arr[$i]} ${vpc_arr[$i]} ${1}

      # get and delete subnets
      GetAndDeleteSubnets ${region_arr[$i]} ${vpc_arr[$i]} ${1}

      # delete vpc
      DeleteVPC ${region_arr[$i]} ${vpc_arr[$i]} ${1}
    fi
  done
fi