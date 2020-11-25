#variables for transit.tf 

variable "vpcA_id" {
    type = string
    default = ""
}

variable "vpcB_id" {
    type = string
    default = ""
}

variable "vpcA_cidr" {
    type = string
    default = ""
}

variable "vpcB_cidr" {
    type = string
    default = ""
}

variable "vpcA_subnet1_id" {
    type = string
    default = ""
}

variable "vpcA_subnet2_id" {
    type = string
    default = ""
}

variable "vpcB_subnet1_id" {
    type = string
    default = ""
}

variable "vpcB_subnet2_id" {
    type = string
    default = ""
}