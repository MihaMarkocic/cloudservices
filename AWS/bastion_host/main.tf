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
	
	pub_sub1_id = module.network.pubSub1ID
	pub_sub2_id = module.network.pubSub2ID
	prvt_sub1_id = module.network.prvtSub1ID
	webserver_sg_id = module.network.webserverSGID
	bastion_sg_id = module.network.bastionSGID
	database_sg_id = module.network.databaseSGID
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