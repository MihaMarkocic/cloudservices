# variables for network.tf

variable "availabilityZone" {
    type = string
    default = "us-east-2a"
}

variable "vpcCIDR" {
    type =  string
    default = "10.0.0.0/16"
}

variable "enableDnsSupport" {
    type = bool
    default = true
}

variable "enableDnsHostnames" {
    type = bool
    default = true
}

variable "pubSubnetCIDR" {
    type = string
    default = "10.0.1.0/24"
}

variable "mapPublicIP" {
    type = bool
    default = true
}

variable "prSubnetCIDR" {
    type = string
    default = "10.0.2.0/24"
}

variable "mapPrivateIP" {
    type = bool
    default = false
}

variable "routeCIDR" {
    type = string
    default = "0.0.0.0/0"
}
