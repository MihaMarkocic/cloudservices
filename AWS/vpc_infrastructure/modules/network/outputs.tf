#outputs of network.tf resources for use in other modules

output "pubSubnetId" {
	value = aws_subnet.publicSubnet.id
	description = "id of public subnet"
}

output "prvtSubnetId" {
	value = aws_subnet.privateSubnet.id
	description = "id of private subnet"
}

output "securityGroupId" {
	value = [ "${aws_default_security_group.default.id}" ]
	description = "id of default security group for ec2 instance"
}