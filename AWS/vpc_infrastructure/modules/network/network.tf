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

resource "aws_subnet" "privateSubnet" {
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
	Name = "myVPC GW"
}
}

#############
# route table
#############

resource "aws_route_table" "publicRT" {
	vpc_id = aws_vpc.myVPC.id
tags = {
	Name = "Public RT"
}
}

resource "aws_route" "publicRoute" {
	route_table_id = aws_route_table.publicRT.id 
	destination_cidr_block = var.routeCIDR
	gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "publicSubnetRT" {
	route_table_id = aws_route_table.publicRT.id
	subnet_id = aws_subnet.publicSubnet.id
}

###############################
# create webserver security group
###############################

resource "aws_security_group" "webserverSG" {
	vpc_id = aws_vpc.myVPC.id
	name = "Webserver/public SG"

	ingress {
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]  
		from_port = 22
		to_port = 22
	}

	ingress {
		protocol = "tcp"
		from_port = 22
		to_port = 22
		security_groups = [aws_security_group.jumpHostSG.id]
	}

	ingress {
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 80
		to_port = 80
	}

	ingress {
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]  
		from_port = 443
		to_port = 443
	}

	egress {
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 80
		to_port = 80
	}

	egress {
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 443
		to_port = 443
	}

	tags = {
		Name = "Webserver security group"
	}
}

#################################
# create jump host security group
#################################
resource "aws_security_group" "jumpHostSG" {
	vpc_id = aws_vpc.myVPC.id
	name = "Jump Host SG"

	ingress {
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"] #ideally your public ip *.*.*./32
		from_port = 22
		to_port = 22
	}

	egress {
		protocol = "tcp"
		cidr_blocks = [var.vpcCIDR]
		from_port = 22
		to_port = 22
	}
	tags = {
		Name = "Jump host security group"
	}
}

########################################
# create private instance security group
########################################

resource "aws_security_group" "privateSG" {
	vpc_id = aws_vpc.myVPC.id
	name = "Private SG"

	ingress {
		protocol = "tcp"
		from_port = 80
		to_port = 80
		security_groups = [aws_security_group.webserverSG.id]
	}

	ingress {
		protocol = "tcp"
		from_port = 80
		to_port = 80
		self = true
	}

	ingress {
		protocol = "tcp"
		from_port = 22
		to_port = 22
		security_groups = [aws_security_group.jumpHostSG.id]
	}

	egress {
		protocol = "tcp"
		from_port = 80
		to_port = 80
		self = true

	}
	tags = {
		Name = "Private security group"
	}
}