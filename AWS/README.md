# AWS provisioning/automation examples
This subdirectory contains a few examples of AWS public cloud deployments. Examples:
 
 - [**vpc_infrastructure**](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/vpc_infrastructure) : basic VPC infrastructure with private/public subnets, IG, route table and webservers. (*Terraform & Ansible*)
 - [**deploy_webserver**](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/deploy_webserver): Provisioning Apache webserver and deploying cloud storage (S3 bucket) in a default AWS network infrastructure. (*Ansible*)
 - [**load_balancer**](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/load_balancer): Network Load Balancer deployed in the public subnet with 3 webservers, distributing the HTTP and HTTPS traffic. (*Terraform & Ansible*)

In order to use and deploy these examples or similar infrastructure, an active *AWS* subscription is needed. Further, automation tool of choice should already be installed in your working environment.

Automation tools: *Ansible*, *Terraform*
