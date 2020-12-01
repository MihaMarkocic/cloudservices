# file to create transit gateway

# create transit gateway 

resource "aws_ec2_transit_gateway" "tgw" {
    auto_accept_shared_attachments = "enable" 
    default_route_table_association = "enable"
    default_route_table_propagation = "enable"
    dns_support = "enable"

    tags = {
        Name = "multicast-tg"
    }
}

#create vpc attachments to tgw

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcAtgw" {
  subnet_ids = ["${var.vpc_a_subnet1_id}"]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = var.vpc_a_id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcBtgw" {
  subnet_ids = ["${var.vpc_b_subnet1_id}"]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = var.vpc_b_id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcCtgw" {
  subnet_ids = ["${var.vpc_c_subnet1_id}"]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = var.vpc_c_id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

#create transit gateway routes

resource "aws_ec2_transit_gateway_route" "routetoA" {
  destination_cidr_block = var.vpc_a_cidr
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpcAtgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}

resource "aws_ec2_transit_gateway_route" "routetoB" {
  destination_cidr_block = var.vpc_b_cidr
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpcBtgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}

resource "aws_ec2_transit_gateway_route" "routetoC" {
  destination_cidr_block = var.vpc_c_cidr
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpcCtgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}

#output transit gateway id
output "tg_id" {
    value = aws_ec2_transit_gateway.tgw.id
}
