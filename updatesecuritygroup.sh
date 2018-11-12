#!/bin/bash
if [ $# -eq 0 ]; then
echo "Usage $0 <Security Group Name1>,<Security Group Name2>"
exit 1
fi
echo "Enter Instance name"
read INSTANCE
echo "Enter region"
read REGION
echo "Enter AWS Cli profile"
read PROFILE
InstanceId=`aws ec2 describe-instances --region $REGION --filters "Name=tag:Name,Values=$INSTANCE" --output text --query 'Reservations[*].Instances[*].InstanceId' --profile $PROFILE`
if [ $? -ne 0 ]; then
	echo "Instance not found in the region"
else
	echo $InstanceId
fi

echo "Updating New Security Groups to $INSTANCE"
aws ec2 modify-instance-attribute --instance-id $InstanceId --groups $(aws ec2 describe-security-groups --filter "Name=group-name,Values=$1,$2" --query "SecurityGroups[].{Id:GroupId}" --output text)
if [ $? -ne 0 ]; then
	echo "Operation Failed"
else
	echo "Successfully updated the SecurityGroups"
fi
