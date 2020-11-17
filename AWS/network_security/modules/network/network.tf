# Network.tf file includes creation of VPC, public and private subnets
# Security groups: one for instances (webservers) in public subnet, another for instances in private subnet (databases)
# Network ACL with allow rules taking into consideration ephemeral ports as well!

### Create VPC

resource "aws_vpc" "myVPC" {
    cidr_block = var.vpcCIDR
    enable_dns_hostnames = var.vpcDnsHost
    enable_dns_support = var.vpcDnsSupp

    tags = {
        Name = "My VPC"
    }
}

### Create public subnet

resource "aws_subnet" "pubSubnet" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.pubSubCIDR
    map_public_ip_on_launch = true
    availability_zone = var.availabilityZone

    tags = {
        Name = "Public subnet"
    }
}

### Create private subnet

resource "aws_subnet" "prvtSubnet" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.prvtSubCIDR
    map_public_ip_on_launch = false
    availability_zone = var.availabilityZone

    tags = {
        Name = "Private subnet"
    }
}

### Create internet gateway

resource "aws_internet_gateway" "myGW" {
    vpc_id = aws_vpc.myVPC.id

    tags = {
        Name = "myVPC IGW" 
    }
}

### Create route table, route and association

resource "aws_route_table" "myRT" {
    vpc_id = aws_vpc.myVPC.id

    tags = {
        Name = "myVPC RT"
    }
}

resource "aws_route" "publicRoute" {
    route_table_id = aws_route_table.myRT.id
    destination_cidr_block = var.destinationCIDR
    gateway_id = aws_internet_gateway.myGW.id
}


resource "aws_route_table_association" "pubSubRT" {
    subnet_id = aws_subnet.pubSubnet.id
    route_table_id = aws_route_table.myRT.id
}

### Create security group

resource "aws_security_group" "pubSG" {
    vpc_id = aws_vpc.myVPC.id
    name = "public subnet SG"

    ingress {
        description = "allow SSH" 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 22
        to_port = 22
    }

    ingress {
        description = "allow TLS"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 443
        to_port = 443
    }

    ingress {
        description = "allow HTTP"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 80
        to_port = 80
    }

    ingress {
        description = "allow ping" 
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 8
        to_port = 0
    }

    ### egress rules

    egress {
        description = "allow HTTP"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 80
        to_port = 80
    }

    egress {
        description = "allow TLS"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 443
        to_port = 443
    }

    egress {
        description = "allow MySQL"
        protocol = "tcp"
        cidr_blocks = [aws_subnet.prvtSubnet.cidr_block]
        from_port = 3306
        to_port = 3306
    }
}

resource "aws_security_group" "prvtSG" {
    vpc_id = aws_vpc.myVPC.id
    name = "private subnet SG"

    ingress {
        description = "allow SSH from public subnet" 
        protocol = "tcp"
        cidr_blocks = [aws_subnet.pubSubnet.cidr_block]
        from_port = 22
        to_port = 22
    }

    ingress {
        description = "allow MySQL from public subnet" 
        protocol = "tcp"
        cidr_blocks = [aws_subnet.pubSubnet.cidr_block]
        from_port = 3306
        to_port = 3306
    }

    ingress {
        description = "allow ping" 
        protocol = "icmp"
        cidr_blocks = [aws_subnet.pubSubnet.cidr_block]
        from_port = 8
        to_port = 0
    }

}


# Create custom Network Access Control List (ACL)

resource "aws_network_acl" "myNACL" {
    vpc_id = aws_vpc.myVPC.id
    subnet_ids = [aws_subnet.pubSubnet.id]

    ingress {
        protocol = "tcp"
        action = "allow"
        rule_no = 100
        cidr_block = "0.0.0.0/0" #put your public ip range!
        from_port = 22
        to_port = 22
    }

    ingress {
        protocol = "tcp"
        action = "allow"
        rule_no = 200
        cidr_block = "0.0.0.0/0" 
        from_port = 80
        to_port = 80
    }

    ingress {
        protocol = "tcp"
        action = "allow"
        rule_no = 300
        cidr_block = "0.0.0.0/0" 
        from_port = 443
        to_port = 443
    }

    #allow ephemeral ports!
    ingress {
        protocol = "tcp"
        action = "allow"
        rule_no = 400
        cidr_block = "0.0.0.0/0" 
        from_port = 1024
        to_port = 65535
    } 

     ingress {
        protocol = "icmp"
        action = "allow"
        rule_no = 500
        cidr_block = "0.0.0.0/0"
        icmp_type = 8
        icmp_code = 0
        from_port = 0
        to_port = 0
    }

    ingress {
        protocol = -1
        action = "deny"
        rule_no = 1000
        cidr_block = "0.0.0.0/0" 
        from_port = 0
        to_port = 0
    }

    ## Egress rules

    egress {
        protocol = "tcp"
        action = "allow"
        rule_no = 100
        cidr_block = "0.0.0.0/0" 
        from_port = 80
        to_port = 80
    }

    egress {
        protocol = "tcp"
        action = "allow"
        rule_no = 200
        cidr_block = "0.0.0.0/0" 
        from_port = 443
        to_port = 443
    }

    egress {
        protocol = "tcp"
        action = "allow"
        rule_no = 300
        cidr_block = "0.0.0.0/0" 
        from_port = 22
        to_port = 22
    }

    egress {
        protocol = "tcp"
        action = "allow"
        rule_no = 400
        cidr_block = aws_subnet.prvtSubnet.cidr_block 
        from_port = 3306
        to_port = 3306
    }

    #allow ephemeral ports!
    egress {
        protocol = "tcp"
        action = "allow"
        rule_no = 500
        cidr_block = "0.0.0.0/0" 
        from_port = 1024
        to_port = 65535
    }

     egress {
        protocol = "icmp"
        action = "allow"
        rule_no = 600
        cidr_block = aws_subnet.prvtSubnet.cidr_block
        icmp_type = 8
        icmp_code = 0
        from_port = 0
        to_port = 0
    }

    egress {
        protocol = -1
        action = "deny"
        rule_no = 1000
        cidr_block = "0.0.0.0/0" 
        from_port = 0
        to_port = 0
    }

    tags = {
        Name = "Public subnet ACL"
    }
}

resource "aws_flow_log" "pubSubnetLogs" {
    log_destination = var.s3arn
    log_destination_type = "s3"
    traffic_type = var.pubLogTraffic
    subnet_id = aws_subnet.pubSubnet.id
}

resource "aws_flow_log" "prvtSubnetLogs" {
    log_destination = var.s3arn
    log_destination_type = "s3"
    traffic_type = var.prvtLogTraffic
    subnet_id = aws_subnet.prvtSubnet.id

}