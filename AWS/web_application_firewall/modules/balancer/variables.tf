# variables for ladbalancing.tf 

variable "alb_name" {
    description = "name of application load balancer"
    type = string
    default = "demo web-alb"
}

variable "alb_security_group_ID" {
    description = "ID of alb security group from Netowrk module"
    type = list(string)
    default = null
}

variable "pub_sub1_ID" {
    description = "ID of a public subnet 1 from Network module" 
    type = string
    default = ""
}

variable "pub_sub2_ID" {
    description = "ID of a public subnet 2 from Network module" 
    type = string
    default = ""
}

variable "vpc_id" {
    description = "VPC ID from Network module"
    type = string
    default = ""
}

variable "web1_ID" {
    description = "webserver 1 ID from compute module"
    type = string
    default = ""
}

variable "web2_ID" {
    description = "webserver 2 ID from compute module"
    type = string
    default = ""
}
