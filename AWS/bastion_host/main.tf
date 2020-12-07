# main terraform module to deploy AWS bastion host infrastructure demo

variable "region" {
	description = "select the region of deployment"
	default = "eu-west-2"
}

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