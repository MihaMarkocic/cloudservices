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
	
	pub_sub1_id = module.network.pub_sub1_ID
	pub_sub2_id = module.network.pub_sub2_ID
	prvt_sub1_id = module.network.prvtSub1ID
	webserver_sg_id = module.network.webserverSGID
	bastion_sg_id = module.network.bastionSGID
	database_sg_id = module.network.databaseSGID
}

module "loadbalancer" {
	source = "./modules/balancer"

	alb_security_group_ID = module.network.alb_sg_ID
	pub_sub1_id = module.network.pub_sub1_ID
	pub_sub2_id = module.network.pub_sub2_ID
	vpc_id =  module.network.vpc_ID
	web1_ID = module.compute.web1_ID
	web2_ID = module.compute.web2_ID
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