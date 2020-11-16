# compute.tf file includes the deployment of instances:
# one instance deployed in public subnet and associated with public SG
# one instance deployed in private subnet adn associated with private SG

data "aws_ami" "ubuntu" {
    owners = ["099720109477"]
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic*"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }
}

resource "aws_instance" "pubInstance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instanceType
    subnet_id = var.pubSubID
    availability_zone = var.availabilityZone
    vpc_security_group_ids = var.pubSgID
    associate_public_ip_address = true
    key_name = var.sshKey

    tags = {
        Name = "Public Instance"
        Type = "server"
    }
}

resource "aws_instance" "prvtInstance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instanceType
    subnet_id = var.prvtSubID
    availability_zone = var.availabilityZone
    vpc_security_group_ids = var.prvtSgID
    associate_public_ip_address = false
    key_name = var.sshKey

    tags = {
        Name = "Private Instance"
        Type = "server"
    }
}