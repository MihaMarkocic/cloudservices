

variable "instanceAmi" {
    description = "Ubuntu Server 18.04 LTS (64-bit)"
    default = "ami-0d5d9d301c853a04a" 
}

variable "instanceType" {
    type = string
    default = "t2.micro"
}

variable "pubSubnetID" {
    description = "public subnet ID from network.tf"
    type = string
    default = ""
}

variable "prvtSubnetID" {
    description = "private subnet ID from network.tf"
    type = string
    default = ""
}

variable "ec2AvailabilityZone" {
    type = string
    default = "us-east-2a"
}

variable "webserverSgId" {
    description = "webserver security group id form network.tf"
    type = list(string)
    default = null
}

variable "jumpHostSgId" {
    description = "jump host security group id form network.tf"
    type = list(string)
    default = null
}

variable "privateSgId" {
    description = "private security group id form network.tf"
    type = list(string)
    default = null
}

variable "pubSshKey" {
    type = string
    default = "id_rsa_webserver"
}

variable "sshKeyLoc" {
    type = string
    default = "~/.ssh/id_rsa_webserver"
}

variable "instanceUser" {
    type = string
    default = "ubuntu"
}