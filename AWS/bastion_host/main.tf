# main terraform module to deploy AWS network infrastructure

# this is required for the terraform 0.13+ version!
#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#    }
#  }
#}


provider "aws" {
    region = var.region
}

module "network" {
    source = "./modules/network"
}

module "instances" {
	source = "./modules/compute"
	
	pubSubnetID = module.network.pubSubnetId
	prvtSubnetID = module.network.prvtSubnetId
	webserverSgId = module.network.webserverSGId
	jumpHostSgId = module.network.jumpHostSGId
	privateSgId = module.network.privateSGId
}

output "webserver_public_ip" {
	value = module.instances.webserverPubIP
}

output "jumpHost_public_ip" {
	value = module.instances.jumpHostPubIP
}

output "private_vm_private_ip" {
	value = module.instances.privateVMprvtIP
}