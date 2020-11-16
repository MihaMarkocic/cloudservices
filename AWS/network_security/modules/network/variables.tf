# variables for network.tf file

variable "vpcCIDR" {
    type = string
    default = "172.19.0.0/17"
}

variable "vpcDnsHost" {
    type = bool
    default = true
}

variable "vpcDnsSupp" {
    type = bool
    default = true
}

variable "availabilityZone" {
    type = string
    default = "us-east-2b"
}

variable "pubSubCIDR" {
    type = string
    default = "172.19.1.0/24"
}

variable "prvtSubCIDR" {
    type = string
    default = "172.19.2.0/24"
}

variable "s3arn" {
    type = string
    default = ""
} 

variable "pubLogTraffic" {
    type = string
    default = "ALL"
}

variable "prvtLogTraffic" {
    type = string
    default = "ACCEPT"
}