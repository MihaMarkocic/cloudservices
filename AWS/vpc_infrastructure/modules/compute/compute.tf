# compute.tf deploying ec2 instances placed in already existing vpc (network.tf)

# deploy webserver in public subnet
resource "aws_instance" "Webserver-pub" {
	ami = var.InstanceAmi
	instance_type = var.InstanceType
	subnet_id = var.pubSubnetID
	availability_zone = var.ec2AvailabilityZone
	vpc_security_group_ids = var.securityGroupID
	associate_public_ip_address = true
	key_name = var.pubSshKey
	
tags = {
	Name = "Public Webserver"
}
}

# deploy webserver in private subnet
resource "aws_instance" "Webserver-prvt" {
	ami = var.InstanceAmi
	instance_type = var.InstanceType
	subnet_id = var.prvtSubnetID
	availability_zone = var.ec2AvailabilityZone
	vpc_security_group_ids = var.securityGroupID
	associate_public_ip_address = false
	key_name = var.pubSshKey
	
tags = {
	Name = "Private Webserver"
}
}