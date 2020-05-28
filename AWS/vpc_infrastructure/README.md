# Virtual network infrastructure deployment Example
In this example, an AWS network infrastructure with webserver, bastion host and private EC2 instance is deployed:

- Network infrastructure:
    1. Create a new VPC *(10.0.0.0/16)*
    2. Create one public *(10.0.1.0/24)* and one private *(10.0.2.0/24)* subnet
    3. Create internet gateway and associate it with VPC
    4. Create a new route table and add a route towards internet gateway for public subnet traffic
    5. Create webserver SG (HTTP, HTTPS from anywhere, SSH from jumphost SG; HTTP, HTTPS to anywhere)
    6. Create jumphost SG (SSH from anywhere*; SSH to VPC range)
    7. Create private SG (SSH from jumphost SG; HTTP from webserver SG and private SG; HTTP to private SG)


- EC2 instance deployment:
    1. Deploy jumpbox instance used for SSH connection to other instances created in the VPC
    2. Deploy webserver instance in public subnet
        - the SSH connection** to this instance is established using key and *bastion_host* option
        - "*remote-exec*" Terraform provisioner is used to update apt-get, and wait for instance to actually launch***
        - "*local-exec*" Terraform provisioner is used to run Ansible playbooks - installation of apache service. Ansible uses dynamic inventory plugin (*aws_ec2*) with appropriate filters to identify the target instance.
    3. Deploy private instance in private subnet


\* *SSH should be allowed only from a particular IP Address (your public IP) or IP Address range. Having it set to "all/anywhere" is used just for demo purposes!*

\** *for an SSH connection to a remote server using a jump box with -J flag (ssh -J user@jumpbox user@destination), an SSH agent must be started and SSH key added*

\*** *Terraform "remote-exec" provisioner waits until the instance is launched, while "local-exec" provisioner starts regardless of the instance status!*
