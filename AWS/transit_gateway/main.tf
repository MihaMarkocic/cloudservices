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
}

module "compute-vpcA" {
    source = "./modules/compute"

    region = var.region
    subne1_id = module.network.
}