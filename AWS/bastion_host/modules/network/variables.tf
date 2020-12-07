# variables for network.tf

variable "region" {
    type = string
    default = ""
}

variable "vpc_cidr" {
    type =  string
    default = "10.0.0.0/16"
}


variable "pub1_cidr" {
    type = string
    default = "10.0.1.0/24"
}

variable "pub2_cidr" {
    type = string
    default = "10.0.2.0/24"
}

variable "prvt1_cidr" {
    type = string
    default = "10.0.3.0/24"
}
