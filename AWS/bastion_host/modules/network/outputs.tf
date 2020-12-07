#outputs of network.tf resources for use in other modules

output "pubSub1Id" {
	value = aws_subnet.publicSub1.id
	description = "id of public subnet 1"
}

output "pubSub2Id" {
	value = aws_subnet.publicSub2.id
	description = "id of public subnet 2"
}

output "prvtSub1Id" {
	value = aws_subnet.privateSub1.id
	description = "id of private subnet 1"
}

output "webserverSGId" {
	value = [ "${aws_security_group.webserverSG.id}" ]
	description = "id of a webserver security group for ec2 instances"
}

output "bastionSGId" {
	value = [ "${aws_security_group.bastionSG.id}" ]
	description = "id of a bastion security group for ec2 instance"
}

output "databaseSGId" {
	value = [ "${aws_security_group.databaseSG.id}" ]
	description = "id of a database security group"
}
