#deploy network infrastructure - vpc, two subnets, ig, route table

###########
#create VPC
###########

resource "aws_vpc" "myVPC" {
	cidr_block = var.vpcCIDR
	enable_dns_support = var.enableDnsSupport
	enable_dns_hostnames = var.enableDnsHostnames

tags = {
	Name = "myVPC"
}
}

################
# create subnets
################

resource "aws_subnet" "publicSubnet" {
	vpc_id = aws_vpc.myVPC.id
	cidr_block = var.pubSubnetCIDR
	map_public_ip_on_launch = var.mapPublicIP
	availability_zone = var.availabilityZone

tags = {
	Name = "Public Subnet"
}
} 

resource "aws_subnet" "private_subnet" {
	vpc_id = aws_vpc.myVPC.id
	cidr_block = var.prSubnetCIDR
	map_public_ip_on_launch = var.mapPrivateIP
	availability_zone = var.availabilityZone
	
tags = {
	Name = "Private Subnet"
}
} 


##################
# internet gateway
##################

resource "aws_internet_gateway" "gw" {
	vpc_id = aws_vpc.myVPC.id

tags = {
	Name = "myVPC IG"
}
}