# compute.tf deploying ec2 instances placed in already existing vpc (network.tf)

# deploy webserver in public subnet
resource "aws_instance" "webserver" {
	ami = var.InstanceAmi
	instance_type = var.InstanceType
	subnet_id = var.pubSubnetID
	availability_zone = var.ec2AvailabilityZone
	vpc_security_group_ids = var.securityGroupID
	associate_public_ip_address = true
	key_name = var.pubSshKey
	
tags = {
	Name = "Webserver"
}
}

# deploy a jump host
resource "aws_instance" "jumpHost" {
	ami = var.InstanceAmi
	instance_type = var.InstanceType
	subnet_id = var.pubSubnetID
	availability_zone = var.ec2AvailabilityZone
	vpc_security_group_ids = var.securityGroupID
	associate_public_ip_address = true
	key_name = var.pubSshKey

tags = {
	Name = "JumpHost"
}
}

#create jump box security group
resource "aws_security_group" "jumpHostSg" {
	name = "Jump Host SSH"
	description = "Allow ssh from the jump host"
	vpc_id = var.vpcID

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${aws_instance.jumpHost.private_ip}/32"]
	}
}


# deploy webserver in private subnet
resource "aws_instance" "privateVM" {
	ami = var.InstanceAmi
	instance_type = var.InstanceType
	subnet_id = var.prvtSubnetID
	availability_zone = var.ec2AvailabilityZone
	vpc_security_group_ids = ["${aws_security_group.jumpHostSg.id}"]
	associate_public_ip_address = false
	key_name = var.pubSshKey
	
tags = {
	Name = "PrivateVM"
}
}