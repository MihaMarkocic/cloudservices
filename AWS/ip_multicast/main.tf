# main terraform file to deploy VPCs, subnets, instances and transit gateway serving as a multicast router 
# enabling multicast communication between instances

variable "region" {
    type = string
    default = "eu-west-2"
}

# define the provider

provider "aws" {
    region = var.region
}

# modules to execute

module "vpc_a" {
    source = "./modules/network"
    
    vpc_cidr = "10.0.0.0/16"
    vpc_name_tag = "VPC-A"
    subnet_cidr = "10.0.1.0/24"
    subnet_name_tag = "subnet1"
    transit_dest_cidr1 = module.vpc_b.vpc_cidr
    transit_dest_cidr2 = module.vpc_c.vpc_cidr
    transit_gateway_id = module.transit.tg_id
}

module "vpc_b" {
    source = "./modules/network"
    
    vpc_cidr = "10.10.0.0/16"
    vpc_name_tag = "VPC-B"
    subnet_cidr = "10.10.1.0/24"
    subnet_name_tag = "subnet1"
    transit_dest_cidr1 = module.vpc_a.vpc_cidr
    transit_dest_cidr2 = module.vpc_c.vpc_cidr
    transit_gateway_id = module.transit.tg_id
}

module "vpc_c" {
    source = "./modules/network"
    
    vpc_cidr = "10.20.0.0/16"
    vpc_name_tag = "VPC-B"
    subnet_cidr = "10.20.1.0/24"
    subnet_name_tag = "subnet1"
    transit_dest_cidr1 = module.vpc_a.vpc_cidr
    transit_dest_cidr2 = module.vpc_b.vpc_cidr
    transit_gateway_id = module.transit.tg_id
}

module "transit" {
    source = "./modules/transit"

    vpc_a_id = module.vpc_a.vpc_id
    vpc_a_cidr = module.vpc_a.vpc_cidr
    vpc_a_subnet1_id = module.vpc_a.subnet_id
    vpc_b_id = module.vpc_b.vpc_id
    vpc_b_cidr = module.vpc_b.vpc_cidr
    vpc_b_subnet1_id = module.vpc_b.subnet_id
    vpc_c_id = module.vpc_c.vpc_id
    vpc_c_cidr = module.vpc_c.vpc_cidr
    vpc_c_subnet1_id = module.vpc_c.subnet_id
}

module "compute_a" {
    source = "./modules/compute"

    subnet_id = module.vpc_a.subnet_id
    security_group_id = module.vpc_a.security_group_id
    instance_name_tag = "webserver_1(VPC-A)"
    instance_role_tag = "multicast_source"
}

module "compute_b" {
    source = "./modules/compute"

    subnet_id = module.vpc_b.subnet_id
    security_group_id = module.vpc_b.security_group_id
    instance_name_tag = "webserver_1(VPC-B)"
    instance_role_tag = "multicast_receiver"
}

module "compute_c" {
    source = "./modules/compute"

    subnet_id = module.vpc_c.subnet_id
    security_group_id = module.vpc_c.security_group_id
    instance_name_tag = "webserver_1(VPC-C)"
    instance_role_tag = "multicast_receiver"
}

output "transit_gateway_id" {
    value = module.transit.tg_id
}