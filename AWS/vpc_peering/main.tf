# main terraform file to deploy VPC peering infrastructure

# Main variables

variable "london" {
    type = string
    default = "eu-west-2"
}

variable "paris" {
    type = string
    default = "eu-west-3"
}

# modules to execute
module "network-london" {
    source = "./modules/network"

    region = var.london 
    vpc_cidr = "172.19.0.0/16"
    vpc_name = "Requester VPC"
    subnetA_cidr = "172.19.1.0/24"
    subnetA_name = "Subnet A"
    subnetB_cidr = "172.19.2.0/24"
    subnetB_name = "Subnet B"
    otherVPC_cidr = module.network-paris.thisVPC_cidr

}

module "network-paris" {
    source = "./modules/network"

    region = var.paris
    vpc_cidr = "172.20.0.0/16"
    vpc_name = "Accepter VPC"
    subnetA_cidr = "172.20.1.0/24"
    subnetA_name = "Subnet A"
    subnetB_cidr = "172.20.2.0/24"
    subnetB_name = "Subnet B"
    otherVPC_cidr = module.network-london.thisVPC_cidr
}

module "compute-london" {
    source = "./modules/compute"

    region = var.london
    subnetA_id = module.network-london.subnetA_id
    subnetB_id = module.network-london.subnetB_id
    security_id = module.network-london.security_id
}

module "compute-paris" {
    source = "./modules/compute"

    region = var.paris
    subnetA_id = module.network-paris.subnetA_id
    subnetB_id = module.network-paris.subnetB_id
    security_id = module.network-paris.security_id
}

# main outputs 
output "instanceA_london_pubIP" {
    value = module.compute-london.instanceAIP
}

output "instanceB_london_pubIP" {
    value = module.compute-london.instanceBIP
}

output "instanceA_paris_pubIP" {
    value = module.compute-paris.instanceAIP
}

output "instanceB_paris_pubIP" {
    value = module.compute-paris.instanceBIP
}