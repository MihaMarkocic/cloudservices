# compute.tf deploying ec2 instances placed in already existing vpc (network.tf)

# deploy a jump host
resource "aws_instance" "jumpHost" {
	ami = var.instanceAmi
	instance_type = var.instanceType
	subnet_id = var.pubSubnetID
	availability_zone = var.ec2AvailabilityZone
	vpc_security_group_ids = var.jumpHostSgId
	associate_public_ip_address = true
	key_name = var.pubSshKey

	tags = {
		Name = "JumpHost"
	}
}

# deploy webserver in public subnet
resource "aws_instance" "webserver" {
	ami = var.instanceAmi
	instance_type = var.instanceType
	subnet_id = var.pubSubnetID
	availability_zone = var.ec2AvailabilityZone
	vpc_security_group_ids = var.webserverSgId
	associate_public_ip_address = true
	key_name = var.pubSshKey
	
	/*
	connection {
		host = self.private_ip
		user = "ubuntu"
		type = "ssh"
		private_key = file("~/.ssh/id_rsa_webserver")
		bastion_host = aws_instance.jumpHost.public_ip
		bastion_private_key = file("~/.ssh/id_rsa_webserver") 
	}

	provisioner "remote-exec" {
		inline = [
			"sudo apt-get -y update",
			"sudo apt-get -y install apache2",
			"sudo service apache2 start",
		]
	}
	*/

	tags = {
		Name = "Webserver"
	}
}


# deploy webserver in private subnet
resource "aws_instance" "privateVM" {
	ami = var.instanceAmi
	instance_type = var.instanceType
	subnet_id = var.prvtSubnetID
	availability_zone = var.ec2AvailabilityZone
	vpc_security_group_ids = var.privateSgId
	associate_public_ip_address = false
	key_name = var.pubSshKey
	
	tags = {
		Name = "PrivateVM"
	}
}