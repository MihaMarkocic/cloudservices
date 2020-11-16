# output values for network.tf file

output "pubSubID" {
    description = "public subnet ID"
    value = aws_subnet.pubSubnet.id
}

output "prvtSubID" {
    description = "private subnet ID"
    value = aws_subnet.prvtSubnet.id
}

output "pubSgID" {
    description = "security group ID for public instances"
    value = ["${aws_security_group.pubSG.id}"]
}

output "prvtSgID" {
    description = "security group ID for private instances"
    value = ["${aws_security_group.prvtSG.id}"]
}