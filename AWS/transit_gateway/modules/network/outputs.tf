# outputs of network.tf

output "vpcA_id" {
    value = aws_vpc.vpcA.id
}

output "vpcB_id" {
    value = aws_vpc.vpcB.id
}

output "vpcA_cidr" {
    value = aws_vpc.vpcA.cidr_block
}

output "vpcB_cidr" {
    value = aws_vpc.vpcB.cidr_block
}

output "vpcA_subnet1_id" {
    description = "vpc a subnet 1 id output"
    value = aws_subnet.vpcAsubnet1.id
}

output "vpcA_subnet2_id" {
    description = "vpc a subnet 2 id output"
    value = aws_subnet.vpcAsubnet2.id
}

output "vpcB_subnet1_id" {
    description = "vpc b subnet 1 id output"
    value = aws_subnet.vpcBsubnet1.id
}

output "vpcB_subnet2_id" {
    description = "vpc B subnet 2 id output"
    value = aws_subnet.vpcBsubnet2.id
}

output "vpcA_sg_id" {
    description = "vpc A custom securtiy group ID"
    value = ["${aws_security_group.customSGvpcA.id}"]
}


output "vpcB_sg_id" {
    description = "vpc B custom securtiy group ID"
    value = ["${aws_security_group.customSGvpcB.id}"]
}