# AWS provisioning/automation examples
This subdirectory contains a few examples of AWS public cloud deployments. Examples:
 
 - [**VPC infrastructure**](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/vpc_infrastructure) : basic VPC infrastructure with private/public subnets, IG, route table and webservers. (*Terraform & Ansible*)
 - [*Webserver deployment**](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/deploy_webserver): Provisioning Apache webserver and deploying cloud storage (S3 bucket) in a default AWS network infrastructure. (*Ansible*)
 - [**Load balancing**](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/load_balancer): Network Load Balancer deployed in the public subnet with 3 webservers, distributing the HTTP and HTTPS traffic. (*Terraform & Ansible*)
 - [**Network security**](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/network_security): Basic AWS infrastructure with public and private subnets, secured with security groups(instance level), custom NACL (subnet level) and monitored with the Flow Logs. (*Terraform*)
 - [**VPC Peering**](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/vpc_peering) : Two VPCs with two subnets and two instances deployed in a different regions and connected with inter-region VPC Peering connection.

In order to use and deploy these examples or similar infrastructure, an active *AWS* subscription is needed. Further, automation tool of choice should already be installed in your working environment.

Automation tools: *Ansible*, *Terraform*
