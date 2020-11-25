# main terraform file to deploy Transit gateway

variable "region" {
    description = "region to deploy infrastructure"
    type = string
    default = "eu-west-2"
}

#define the provider

provider "aws" {
    region = var.region
}

# modules to execute

module "network" {
    source = "./modules/network"

    region = var.region
    transit_gateway_id = module.transit-gateway.transit_gateway_id
}

module "transit-gateway" {
    source = "./modules/transit"

    vpcA_id = module.network.vpcA_id
    vpcA_cidr = module.network.vpcA_cidr
    vpcB_id = module.network.vpcB_id
    vpcB_cidr = module.network.vpcB_cidr
    vpcA_subnet1_id = module.network.vpcA_subnet1_id
    vpcA_subnet2_id = module.network.vpcA_subnet2_id
    vpcB_subnet1_id = module.network.vpcB_subnet1_id
    vpcB_subnet2_id = module.network.vpcB_subnet2_id
}

module "compute-vpcA" {
    source = "./modules/compute"

    region = var.region
    subnet1_id = module.network.vpcA_subnet1_id
    subnet2_id = module.network.vpcA_subnet2_id
    security_id = module.network.vpcA_sg_id
}

module "compute-vpcB" {
    source = "./modules/compute"

    region = var.region
    subnet1_id = module.network.vpcB_subnet1_id
    subnet2_id = module.network.vpcB_subnet2_id
    security_id = module.network.vpcB_sg_id
}