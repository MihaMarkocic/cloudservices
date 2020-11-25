#file to create transit gateway between vpcA and vpcB

# create transit gateway

resource "aws_ec2_transit_gateway" "tgw" {
    auto_accept_shared_attachments = "enable"
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"
    dns_support = "enable"

    tags = {
        Name = "transit gw A-B"
    }
}

# create transit gateway route table

resource "aws_ec2_transit_gateway_route_table" "tgwRT" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

#create vpc attachments to tgw

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcAtgw" {
  subnet_ids = ["${var.vpcA_subnet1_id}",
                "${var.vpcA_subnet2_id}"]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = var.vpcA_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "vpcBtgw" {
  subnet_ids = ["${var.vpcB_subnet1_id}",
                "${var.vpcB_subnet2_id}"]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = var.vpcB_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

#create transit gateway routes

resource "aws_ec2_transit_gateway_route" "transitAtoB" {
  destination_cidr_block = var.vpcB_cidr
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpcAtgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwRT.id
}

resource "aws_ec2_transit_gateway_route" "transitBtoA" {
  destination_cidr_block = var.vpcA_cidr
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpcBtgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwRT.id
}

# create associations - attachment of VPC A to transit gateway and transit gateway route table

resource "aws_ec2_transit_gateway_route_table_association" "associateA" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcAtgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwRT.id
}

# create associations - attachment of VPC B to transit gateway and transit gateway route table

resource "aws_ec2_transit_gateway_route_table_association" "associateB" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcBtgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwRT.id
}

# create propagation - attachment of VPC A to transit gateway and transit gateway route table

resource "aws_ec2_transit_gateway_route_table_propagation" "propagateA" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcAtgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwRT.id
}

# create propagation - attachment of VPC B to transit gateway and transit gateway route table

resource "aws_ec2_transit_gateway_route_table_propagation" "propagateB" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpcBtgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwRT.id
}

# define outputs needed in other modules

output "transit_gateway_id" {
    value = aws_ec2_transit_gateway.tgw.id
}