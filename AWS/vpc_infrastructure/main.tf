# main terraform module to deploy AWS network infrastructure

provider "aws" {
    region = var.region
}

module "network" {
    source = "./modules/network"
}

module "webservers" {
	source = "./modules/compute"
	
	pubSubnetID = module.network.pubSubnetId
	prvtSubnetID = module.network.prvtSubnetId
	securityGroupID = module.network.securityGroupId
}