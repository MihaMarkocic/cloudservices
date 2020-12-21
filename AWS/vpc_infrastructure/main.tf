# terraform file to deploy a basic AWS infrastructure consisting of VPC, subnets, route tables and IG.

provider "aws" {
    region = var.region
    version = "~> 3.0"
}

# get availability zones
data "aws_availability_zones" "available" {
	state = "available"
}

# create VPC
resource "aws_vpc" "demoVPC" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "demo VPC"
    }
}

# create public subnet
resource "aws_subnet" "pubSub" {
    vpc_id = aws_vpc.demoVPC.id
    cidr_block = var.pub_subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "Public 1"
    }
} 

# create private subnet
resource "aws_subnet" "prvtSub" {
    vpc_id = aws_vpc.demoVPC.id
    cidr_block = var.prvt_subnet_cidr
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "Private 1"
    }
}

#create internet gateway 
resource "aws_internet_gateway" "demoIG" {
    vpc_id = aws_vpc.demoVPC.id

    tags = {
        Name = "demo IGW"
    }
}

#create Route Table
resource "aws_route_table" "demoRT" {
    vpc_id = aws_vpc.demoVPC.id

    tags = {
        Name = "demo RT"
    }
}

#create route 
resource "aws_route" "publicRoute" {
    route_table_id = aws_route_table.demoRT.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demoIG.id 
}

#associate public subnet with the route table
resource "aws_route_table_association" "associatePubSub" {
    subnet_id = aws_subnet.pubSub.id
    route_table_id = aws_route_table.demoRT.id
}
