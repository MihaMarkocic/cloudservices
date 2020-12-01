# terraform file for creating : VPC, subnets, route table, internet gateway and security group

resource "aws_vpc" "myVPC" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = var.vpc_name_tag
    } 
}

# Create a subnet in the VPC

resource "aws_subnet" "mySubnet" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.subnet_cidr
    map_public_ip_on_launch = true 
    availability_zone = "${var.region}a"

    tags = {
        Name = "${var.vpc_name_tag}-${var.subnet_name_tag}"        
    } 
}

# Create internet gateway

resource "aws_internet_gateway" "myIG" {
    vpc_id = aws_vpc.myVPC.id

    tags = {
        Name = "${var.vpc_name_tag}-IGW"
    }
}

# Create route table and associate subnet with it

resource "aws_route_table" "myRT" {
    vpc_id = aws_vpc.myVPC.id

    tags = {
        Name = "${var.vpc_name_tag}-RT"
    }
}

resource "aws_route_table_association" "associateRT" {
    subnet_id = aws_subnet.mySubnet.id
    route_table_id = aws_route_table.myRT.id
}

# create custom routes

resource "aws_route" "publicRoute" {
    route_table_id = aws_route_table.myRT.id
    destination_cidr_block = var.public_dest_cidr
    gateway_id = aws_internet_gateway.myIG.id
}

# routes to transit gateway

resource "aws_route" "transitRoute1" {
    route_table_id = aws_route_table.myRT.id
    destination_cidr_block = var.transit_dest_cidr1
    transit_gateway_id = var.transit_gateway_id
}

resource "aws_route" "transitRoute2" {
    route_table_id = aws_route_table.myRT.id
    destination_cidr_block = var.transit_dest_cidr2
    transit_gateway_id = var.transit_gateway_id
}

# security group

resource "aws_security_group" "customSG" {
    description = "custom security group to test transit gateway IP multicast"
    vpc_id = aws_vpc.myVPC.id

    ingress {
        description = "allow SSH"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # ideally your public IP range!!
        from_port = 22
        to_port = 22
    }

    ingress {
        description = "allow HTTP from owned VPCs"
        protocol = "tcp"
        cidr_blocks = [var.transit_dest_cidr1, var.transit_dest_cidr2]
        from_port = 80
        to_port = 80
    }

    ingress {
        description = "allow custom multicast UDP traffic"
        protocol = "udp"
        cidr_blocks = [aws_vpc.myVPC.cidr_block, var.transit_dest_cidr1, var.transit_dest_cidr2]
        from_port = 143
        to_port = 143
    }

    ingress {
        description = "allow ping test from owned VPCs"
        protocol = "icmp"
        cidr_blocks = [var.transit_dest_cidr1, var.transit_dest_cidr2]
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