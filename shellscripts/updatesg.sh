#!/bin/bash
echo "Getting instance by name"
instance_id=$(aws ec2 describe-instances --filters Name=vpc-id,Values=$1 --query "Reservations[*].Instances[*].InstanceId" --output text)
echo "Instance ID's calculated, entering for loop now"
for i in $instance_id
do
	instance_name=$(aws ec2 describe-tags --filters Name=resource-id,Values=$i Name=key,Values=Name --query Tags[].Value --output text)
	if [[ $instance_name == *"PatternToMatch"* ]] && ([[ $instance_name != *"pay"* ]] && [[ $instance_name != *"psh"* ]]); then
		interface_id=$(aws ec2 describe-network-interfaces --filters Name=attachment.instance-id,Values=$i Name=attachment.device-index,Values=0 --query "NetworkInterfaces[*].NetworkInterfaceId" --output text)
		#echo "InstanceName=$instance_name and InterfaceId=$interface_id"
		echo "Modifying Sg for $instance_name:$interface_id"
		aws ec2 modify-network-interface-attribute --network-interface-id $interface_id --groups <Groups Id>
	fi
done
echo "Sg updated....script complete"
