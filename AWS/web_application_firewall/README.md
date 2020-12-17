# Web Application Firewall & Application Load Balancer Example
This example demonstrates how to set up and deploy a Web Application Firewall (WAF) together with Application Load Balancer (ALB) in an AWS cloud deployment. WAF lets you monitor the HTTP and HTTPS requests forwarded to the ALB and enables you to control the access to your content based on conditions that you specify. ALB serves as a single contact point and automatically distributes the incoming application traffic among multiple targets such as EC2 instances in one or more availability zones. This way, the availability of your service/application is increased. 

## Details
The infrastructure consists of one VPC with 3 subnets (2 public and 1 private). Public subnets are associated with custom route table and a route to the external network through a custom internet gateway. Both public subnets have one webserver, while private subnet has a private instance (such as a database). Jump host is deployed in one of the public subnets and serves the purpose to provide the SSH connection to other instances. The accessibility of each instance is limited with custom security groups. The HTTP traffic incoming to the webservers is automatically distributed by Application Load Balancer and monitored/controlled by the WAF. 

[*main.tf*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/web_application_firewall/main.tf) file is the main Terraform file used to deploy this demo. This is where the region of deployment, provider and modules are defined. Network infrastructure part of this deployment, including subnet route table internet gateway and security groups creation, is defined in the *Network module*. Deployment of EC2 instances (webservers, private instances and bastion host) is defined in *Compute module*. Application load balancer with defined target groups and listeners for HTTP traffic is defined in *Balancer module* and the Web application firewall in *WAF module*. Apart from modules, short initialization files for webservers and bastion host are available in a separate *init_files* folder.

### Modules
- [*Network*](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/web_application_firewall/modules/network):
    1. Create a new VPC *(172.19.0.0/16)*
    2. Create two public *(172.19.1.0/24 & 172.19.2.0/24)* and one private *(172.19.3.0/24)* subnet
    3. Create internet gateway and associate it with VPC
    4. Create a new route table and add a route to an external network through the internet gateway. Associate both public subnets with a custom route table.
    5. Create security groups for different instance types: 
        - Webserver security group (HTTP and HTTPS allowed from anywhere, SSH allowed from bastion SG; all outbound traffic allowed)
        - Bastion security group (SSH allowed from anywhere*; all outbound traffic allowed)
        - Database/private security group (SSH allowed from bastion SG; HTTP and MySQL allowed from webserver SG and private SG; all outbound traffic allowed)
        - Application Load Balancer security group (HTTP and HTTPS incoming traffic allowed; all outgoing traffic allowed)


- [*Compute*](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/web_application_firewall/modules/compute):
    1. Obtain AWS AMI ID for the desired os *(Ubuntu Server 20.04 LTS from Canonical)* in a defined region
    2. Deploy bastion host instance in a public subnet and:
        - define connection parameters (ssh key, IP address and user) for provisioner
        - use *remote-exec* Terraform provisioner to download [*bastion initialization*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/web_application_firewall/init_files/bastion_init.sh) shell script from this Github repository and run it to configure firewall rules 
    2. Deploy webserver instances in every public subnet and:
        - define connection parameters (ssh key, IP address, user and bastion host) through bastion host for the provisioner
        - use *remote-exec* Terraform provisioner to download [*webserver initialization*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/web_application_firewall/init_files/webserver_init.sh) script from this Github repository and run it to install apache2 service and configure firewall rules. Additionally, index.html is replaced and appropriate modules set up to enable SSI on the servers.
    3. Deploy database instance in a private subnet

- [*Balancer*](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/web_application_firewall/modules/balancer):
    1. Elastic Load Balancer is deployed as an external application load balancer, with defined security group and range of subnets.
    2. Set up an HTTP *target group* required to route the specific traffic (in this case HTTP on port 80) to the registered targets.
    3. Attach both webservers to the defined HTTP target group.
    4. Create a *listener* that checks the requests from the clients using protocol and port configured. Listener forwards HTTP traffic coming to port 80 to the defined HTTP *target group*.

- [*WAF*](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/web_application_firewall/modules/waf)
    1. Define regular expression patterns that you want a web application firewall to search for (example: *admin*, *login* and *registration*)
    2. Define a web application firewall access control list with the default action to allow requests that are not captured by the rules.
        - Add a special rule, to block all the requests that have a specific predefined *regular expression* included in the URL.
    3. Associate the web application firewall access control list with the application load balancer.

\* *SSH should be allowed only from a particular IP Address (your public IP) or IP Address range. Having it set to "all/anywhere" is used just for demo purposes!*

## Deployment
This section provides a short description of the steps you need to perform in order to deploy and test the infrastructure. Move to the cloned git repo where the *main.tf* file is and initialize Terraform with `terraform init` command and then deploy the infrastructure with `terraform plan` and `terraform apply` commands. After the successful deployment, the outputs of instance private/public IP addresses are printed.

1. Testing the ALB: visit the URL of the application load balancer, which you can find among the Terraform outputs. By revisiting the site multiple times, you will notice the requests are distributed among both webservers (webserver name is printed on the site, as well as *ifconfig* info).
2. Testing the WAF: By default, the requests made to the ALB are allowed. However specific expression patterns in the URL are set to be blocked. Those expressions are *login*, *admin* and *registration*. By including any of those expressions after the URL of the ALB ( *UrlOfTheALB.elb.amazonaws.com/login* ), the WAF should block the request and *403 Forbidden* should appear on the screen.
