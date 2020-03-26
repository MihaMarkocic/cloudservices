# main terraform module to deploy AWS network infrastructure

provider "aws" {
    region = var.region
}

module "network" {
    source = "./modules/network"
}
