# outputs of network.tf

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