# Bastion host deployment Example
This example demonstrates how to set up and deploy a Bastion host in an AWS cloud deployment. A bastion host is a server whose purpose is to provide access to other/private instances in your network. This way, you can mitigate the risk of allowing SSH connection from an external network to your private instances in a VPC. 

## Details
The infrastructure consists of one VPC with 3 subnets (2 public and 1 private). Public subnets are associated with custom route table and a route to the external network through a custom internet gateway. Both public subnets have one webserver, while private subnet has a private instance (such as a database). Bastion host *(also Jump host)* is deployed in one of the public subnets, and serves the purpose to provide the SSH connection to other instances. The accessibility of each instance is limited with custom security groups. Webservers are allowed HTTP and HTTPS traffic from an outside network, while database instance is allowed MySQL and HTTP from public subnets only. Both types of instances allow SSH connection from the bastion host security group only. A bastion host has its own security group allowing only SSH connection.

[*main.tf*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/bastion_host/main.tf) file is the main Terraform file used to deploy this demo. This is where the region of deployment, provider and modules are defined. Network infrastructure part of this deployment, including subnet route table internet gateway and security groups creation, is defined in the *Network module*. Deployment of EC2 instances (webservers, private instances and bastion host) is defined in *Compute module*. Apart from modules, short initialization files for webservers and bastion host are available in a separate *init_files* folder.

### Modules
- [*Network*](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/bastion_host/modules/network):
    1. Create a new VPC *(10.0.0.0/16)*
    2. Create two public *(10.0.1.0/24 & 10.0.1.0/24)* and one private *(10.0.3.0/24)* subnet
    3. Create internet gateway and associate it with VPC
    4. Create a new route table and add a route to an external network through the internet gateway
    5. Create security groups for different instance types: 
        - Webserver security group (HTTP and HTTPS allowed from anywhere, SSH allowed from bastion SG; all outbound traffic allowed)
        - Bastion security group (SSH allowed from anywhere*; all outbound traffic allowed)
        - Database/private security group (SSH allowed from bastion SG; HTTP and MySQL allowed from webserver SG and private SG; all outbound traffic allowed)


- [*Compute*](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/bastion_host/modules/compute):
    1. Obtain AWS AMI ID for the desired os *(Ubuntu Server 20.04 LTS from Canonical)* in a defined region
    2. Deploy bastion host instance in a public subnet and:
        - define connection parameters (ssh key, IP address and user) for provisioner
        - use *remote-exec* Terraform provisioner to download [*bastion initialization*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/bastion_host/init_files/bastion_init.sh) shell script from this Github repository and run it to install apache2 service and configure firewall rules 
    2. Deploy webserver instances in every public subnet and:
        - define connection parameters (ssh key, IP address, user and bastion host) through bastion host for the provisioner
        - use *remote-exec* Terraform provisioner to download [*webserver initialization*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/bastion_host/init_files/webserver_init.sh) script from this Github repository and run it to install apache2 service and configure firewall rules
    3. Deploy database instance in a private subnet

\* *SSH should be allowed only from a particular IP Address (your public IP) or IP Address range. Having it set to "all/anywhere" is used just for demo purposes!*

## Deployment
This section provides a short description of the steps you need to perform in order to deploy and test the infrastructure. Move to the cloned git repo where the *main.tf* file is and initialize Terraform with `terraform init` command and then deploy the infrastructure with `terraform plan` and `terraform apply` commands. After the successful deployment, the outputs of instance private/public IP addresses are printed.

To test whether the bastion host provides you with access to other instances initialize an *ssh-agent* with `eval 'ssh-agent'` command. Afterwards, add your ssh-key (the one defined in terraform scripts) to the agent with `ssh-add *yourkey*` command. When this is configured you can use ssh command and try to connect to the instances:
- `ssh -i *path/to/key* user@bastion_ip_address ` to test the Bastion host reachability
- For an SSH connection to a remote server, use an ssh command with -J flag: `ssh -J user@bastion_ip user@server_ip` 
