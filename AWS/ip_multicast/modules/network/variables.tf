# variables for network.tf

variable "region" {
    description = "define region to deploy infrastructure in"
    type = string
    default = "eu-west-2" 
}

variable "vpc_cidr" {
    description = "vpc cidr block"
    type = string
    default = ""
}

variable "vpc_name_tag" {
    description = "vpc name"
    type = string
    default = ""
}

variable "subnet_cidr" {
    description = "subnet cidr block"
    type = string
    default = ""
}

variable "subnet_name_tag" {
    description = "subnet name"
    type = string
    default = ""
}

variable "public_dest_cidr" {
    description = "packets destination cidr for internet"
    type = string
    default = "0.0.0.0/0"
}

variable "transit_dest_cidr1" {
    description = "packets destination cidr over transit gateway 1st connection"
    type = string
    default = ""
}

variable "multicast_dest_cidr" {
    description = "multicast group ip address"
    type = string
    default = "239.0.0.1/32"
}

variable "transit_gateway_id" {
    description = "id of created Transit Gateway"
    type = string
    default = "" 
}