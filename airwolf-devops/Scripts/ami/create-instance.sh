#!/bin/sh
  
profile=$1
imageId=$2
instancetype=$3
keypair=$4
securitygrpId=$5
subnetId=$6
tagname=$7

echo "Creating ec2-instance for AMI-ID $imageId...\n"
aws ec2 run-instances --profile $profile --region "us-east-1" --image-id $imageId --count 1 --instance-type $instancetype --key-name $keypair --security-group-ids $securitygrpId --subnet-id $subnetId --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$tagname}]"

if [ $? -eq 0 ]; then
        echo "Instance creation request complete!\n"
fi