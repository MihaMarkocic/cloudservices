#outputs of network.tf resources for use in other modules

output "pubSubnetId" {
	value = aws_subnet.publicSubnet.id
	description = "id of public subnet"
}

output "prvtSubnetId" {
	value = aws_subnet.privateSubnet.id
	description = "id of private subnet"
}

output "webserverSGId" {
	value = [ "${aws_security_group.webserverSG.id}" ]
	description = "id of a webserver security group for ec2 instance"
}

output "jumpHostSGId" {
	value = [ "${aws_security_group.jumpHostSG.id}" ]
	description = "id of a jump host security group for ec2 instance"
}

output "privateSGId" {
	value = [ "${aws_security_group.privateSG.id}" ]
	description = "id of a private security group for ec2 instance"
}
