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

output "webserver1_public_ip" {
	value = module.instances.webserver1PubIP
}

output "webserver1_private_ip" {
	value = module.instances.webserver1PrvtIP
}

output "webserver2_public_ip" {
	value = module.instances.webserver2PubIP
}

output "webserver2_private_ip" {
	value = module.instances.webserver2PrvtIP
}

output "jumphost_public_ip" {
	value = module.instances.bastionPubIP
}

output "database_private_ip" {
	value = module.instances.databasePrvtIP
}