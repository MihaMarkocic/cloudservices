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
		type = "bastionhost"
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
	

	connection {
		host = self.private_ip
		user = var.instanceUser
		type = "ssh"
		private_key = file(var.sshKeyLoc)
		bastion_host = aws_instance.jumpHost.public_ip
		bastion_private_key = file(var.sshKeyLoc) 
	}
	
	provisioner "remote-exec" {
		inline = [
			"sudo apt-get -y update",
		]
	}

	provisioner "local-exec" {
		command = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -u ${var.instanceUser} --private-key ${var.sshKeyLoc} -i ./inventory/aws_ec2.yaml provision_instances.yaml"
	}


	tags = {
		Name = "Webserver"
		type = "webserver"
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
		type = "private"
	}
}