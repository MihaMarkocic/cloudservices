# network terraform file to deploy VPC and 2 subnets


# Create VPC A

resource "aws_vpc" "vpcA" {
    cidr_block = var.vpcA_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = var.vpcA_name
    } 
}

# Create subnets in VPC A

resource "aws_subnet" "vpcAsubnet1" {
    vpc_id = aws_vpc.vpcA.id
    cidr_block = var.vpcA_subnet1_cidr
    map_public_ip_on_launch = true 
    availability_zone = "${var.region}a"

    tags = {
        Name = var.vpcA_subnet1_name
    } 
}

resource "aws_subnet" "vpcAsubnet2" {
    vpc_id = aws_vpc.vpcA.id
    cidr_block = var.vpcA_subnet2_cidr
    map_public_ip_on_launch = true 
    availability_zone = "${var.region}b"

    tags = {
        Name = var.vpcA_subnet2_name
    } 
}

# Create VPC B

resource "aws_vpc" "vpcB" {
    cidr_block = var.vpcB_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = var.vpcB_name
    } 
}

# Create subnets in VPC A

resource "aws_subnet" "vpcBsubnet1" {
    vpc_id = aws_vpc.vpcB.id
    cidr_block = var.vpcB_subnet1_cidr
    map_public_ip_on_launch = true 
    availability_zone = "${var.region}a"

    tags = {
        Name = var.vpcB_subnet1_name
    } 
}

resource "aws_subnet" "vpcBsubnet2" {
    vpc_id = aws_vpc.vpcB.id
    cidr_block = var.vpcB_subnet2_cidr
    map_public_ip_on_launch = true 
    availability_zone = "${var.region}b"

    tags = {
        Name = var.vpcB_subnet2_name
    } 
}

# Create security groups

resource "aws_security_group" "customSGvpcA" {
    description = "custom security group to test transit gateway connection"
    vpc_id = aws_vpc.vpcA.id

    ingress {
        description = "allow SSH"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # ideally your public IP range!!
        from_port = 22
        to_port = 22
    }

    ingress {
        description = "allow HTTP from other VPCs"
        protocol = "tcp"
        cidr_blocks = [aws_vpc.vpcB.cidr_block]
        from_port = 80
        to_port = 80
    }

    ingress {
        description = "allow ping test from other VPCs"
        protocol = "icmp"
        cidr_blocks = [aws_vpc.vpcB.cidr_block]
        from_port = 8  # icmp type number
        to_port = 0 # icmp code
        
    }

    egress {
        description = "allow all outbound traffic"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
    }
}

resource "aws_security_group" "customSGvpcB" {
    description = "custom security group to test transit gateway connection"
    vpc_id = aws_vpc.vpcB.id

    ingress {
        description = "allow SSH"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # ideally your public IP range!!
        from_port = 22
        to_port = 22
    }

    ingress {
        description = "allow HTTP from other VPCs"
        protocol = "tcp"
        cidr_blocks = [aws_vpc.vpcA.cidr_block]
        from_port = 80
        to_port = 80
    }

    ingress {
        description = "allow ping test from other VPCs"
        protocol = "icmp"
        cidr_blocks = [aws_vpc.vpcA.cidr_block]
        from_port = 8  # icmp type number
        to_port = 0 # icmp code
        
    }

    egress {
        description = "allow all outbound traffic"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
    }
}

# Create internet gateway

resource "aws_internet_gateway" "vpcAgw" {
    vpc_id = aws_vpc.vpcA.id

    tags = {
        Name = "vpcA IGW" 
    }
}

resource "aws_internet_gateway" "vpcBgw" {
    vpc_id = aws_vpc.vpcB.id

    tags = {
        Name = "vpcB IGW" 
    }
}

# Create route table for vpcA and vpcB

resource "aws_route_table" "rtA" {
    vpc_id = aws_vpc.vpcA.id

    tags = {
        Name = "${var.vpcA_name}-RT"
    }
}

resource "aws_route_table_association" "Asub1Route" {
    subnet_id = aws_subnet.vpcAsubnet1.id
    route_table_id = aws_route_table.rtA.id
}

resource "aws_route_table_association" "Asub2Route" {
    subnet_id = aws_subnet.vpcAsubnet2.id
    route_table_id = aws_route_table.rtA.id
}

resource "aws_route_table" "rtB" {
    vpc_id = aws_vpc.vpcB.id

    tags = {
        Name = "${var.vpcB_name}-RT"
    }
}

resource "aws_route_table_association" "Bsub1Route" {
    subnet_id = aws_subnet.vpcBsubnet1.id
    route_table_id = aws_route_table.rtB.id
}

resource "aws_route_table_association" "Bsub2Route" {
    subnet_id = aws_subnet.vpcBsubnet2.id
    route_table_id = aws_route_table.rtB.id
}

resource "aws_route" "publicRouteVPCA" {
    route_table_id = aws_route_table.rtA.id
    destination_cidr_block = var.destination_cidr
    gateway_id = aws_internet_gateway.vpcAgw.id
}

resource "aws_route" "publicRouteVPCB" {
    route_table_id = aws_route_table.rtB.id
    destination_cidr_block = var.destination_cidr
    gateway_id = aws_internet_gateway.vpcBgw.id
}

# routes to transit gateway

resource "aws_route" "AtoTGW" {
    route_table_id = aws_route_table.rtA.id
    destination_cidr_block = aws_vpc.vpcB.cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "BtoTGW" {
    route_table_id = aws_route_table.rtB.id
    destination_cidr_block = aws_vpc.vpcA.cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}




# create transit gateway

resource "aws_ec2_transit_gateway" "tgw" {
    auto_accept_shared_attachments = "enable"
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"
    dns_support = "enable"

    tags = {
        Name = "test transit-gw"
    }
}

# create transit gateway route table

resource "aws_ec2_transit_gateway_route_table" "tgwRT" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

#create vpc attachments to tgw

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcAtgw" {
  subnet_ids = [aws_subnet.vpcAsubnet1.id,
                aws_subnet.vpcAsubnet2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = aws_vpc.vpcA.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "vpcBtgw" {
  subnet_ids = [aws_subnet.vpcBsubnet1.id, 
                aws_subnet.vpcBsubnet2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = aws_vpc.vpcB.id
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