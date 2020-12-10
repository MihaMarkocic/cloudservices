#outputs of network.tf resources for use in other modules

output "pubSub1ID" {
	value = aws_subnet.publicSub1.id
	description = "id of public subnet 1"
}

output "pubSub2ID" {
	value = aws_subnet.publicSub2.id
	description = "id of public subnet 2"
}

output "prvtSub1ID" {
	value = aws_subnet.privateSub1.id
	description = "id of private subnet 1"
}

output "webserverSGID" {
	value = [ "${aws_security_group.webserverSG.id}" ]
	description = "id of a webserver security group for ec2 instances"
}

output "bastionSGID" {
	value = [ "${aws_security_group.bastionSG.id}" ]
	description = "id of a bastion security group for ec2 instance"
}

output "databaseSGID" {
	value = [ "${aws_security_group.databaseSG.id}" ]
	description = "id of a database security group"
}

output "albSGID" {
	value = ["${aws_security_group.albSG.id}"]
	description = "id of application load balancer security group"
}
