# variables for vpc_infrastructure

variable "region" {
    type = string
    default = "eu-west-2"
}

variable "vpc_cidr" {
    type = string
    default = "172.19.0.0/16"
}

variable "pub_subnet_cidr" {
    type = string
    default = "172.19.1.0/24"
}

variable "prvt_subnet_cidr" {
    type = string
    default = "172.19.2.0/24"
}