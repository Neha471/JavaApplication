#!/bin/sh
  
ami_discription="Migration from EC2 classic to VPC EC2 instance"
profile=$1
instanceId=$2
aminame=$3
tagname=$4

echo "Requesting AMI for Instance-Id $instanceId...\n"
imageId=($(aws ec2 create-image --profile $profile --region "us-east-1" --instance-id $instanceId --name $aminame --description "$ami_discription" --no-reboot --output text))

aws ec2 create-tags --profile $1 --region "us-east-1" --resources $imageId --tags Key=Name,Value=$tagname

echo $imageId

if [ $? -eq 0 ]; then
        echo "AMI request complete!\n"
fi