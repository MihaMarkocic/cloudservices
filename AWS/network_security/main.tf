# main terraform module to explore, configure and deploy network security in AWS

provider "aws" {
    region = "us-east-2"
}

module "storage" {
    source = "./modules/storage"
}

module "network" {
    source = "./modules/network"

    s3arn = module.storage.s3arn
}

module "compute" {
    source = "./modules/compute"

    pubSubID = module.network.pubSubID
    prvtSubID = module.network.prvtSubID
    pubSgID = module.network.pubSgID
    prvtSgID = module.network.prvtSgID
}

