# variables for network.tf

variable "region" {
    type = string
    default = ""
}

variable "vpcA_cidr" {
    description = "vpcA CIDR block"
    type = string
    default = "172.19.0.0/16"
}

variable "vpcA_name" {
    description = "vpcA name"
    type = string
    default = "VPC A"
}

variable "vpcB_cidr" {
    description = "vpcB CIDR block"
    type = string
    default = "172.20.0.0/16"
}

variable "vpcB_name" {
    description = "vpcB name"
    type = string
    default = "VPC B"
}

variable "vpcA_subnet1_cidr" {
    description = "cidr block for subnet 1"
    type = string
    default = "172.19.1.0/24"
}

variable "vpcA_subnet1_name" {
    description = "subnet 1 name"
    type = string
    default = "A subnet1"
}

variable "vpcA_subnet2_cidr" {
    description = "cidr block for subnet 2"
    type = string
    default = "172.19.2.0/24"
}

variable "vpcA_subnet2_name" {
    description = "subnet 2 name"
    type = string
    default = "A subnet2"
}

variable "vpcB_subnet1_cidr" {
    description = "cidr block for subnet 1"
    type = string
    default = "172.20.1.0/24"
}

variable "vpcB_subnet1_name" {
    description = "subnet 1 name"
    type = string
    default = "B subnet1"
}

variable "vpcB_subnet2_cidr" {
    description = "cidr block for subnet 2"
    type = string
    default = "172.20.2.0/24"
}

variable "vpcB_subnet2_name" {
    description = "subnet 2 name"
    type = string
    default = "B subnet2"
}

variable "destination_cidr" {
    description = "Route destination cidr"
    type = string
    default = "0.0.0.0/0"
}
