# variables for the compute.tf file

variable "pubSubID" {
    type = string
    default = ""
}

variable "prvtSubID" {
    type = string
    default = ""
}

variable "pubSgID" {
    type = list(string)
    default = null
}

variable "prvtSgID" {
    type = list(string)
    default = null
}

variable "pubInstanceName" {
    type = string
    default = "Public Instance"
}

variable "instanceType" {
    type = string
    default = "t2.micro"
}

variable "availabilityZone" {
    type = string
    default = "us-east-2b"
}

variable "sshKey" {
    type = string
    default = "id_rsa_webserver"
}
