# Virtual network infrastructure deployment Example
In this example, an AWS network infrastructure (VPC and public subnet) with 3 webservers and a network load balancer is deployed:

- Network infrastructure:
    1. Create a new VPC *(10.0.0.0/16)*
    2. Create one public *(10.0.1.0/24)* subnet
    3. Create internet gateway and associate it with VPC
    4. Create a new route table and add a route towards internet gateway for public subnet traffic
    5. Create webserver SG *(HTTP, HTTPS from anywhere; HTTP, HTTPS to anywhere)*

- EC2 instance deployment:
    1. Obtain AWS AMI ID for the desired os *(Ubuntu Server 18.04 LTS from Canonical)*
    2. Deploy 3 webserver instances in a created public subnet

- Load Balancer:
    1. Deploy network load balancer in a public subnet with 3 webserver instances
    2. Create 2 load balancer listeners listening to the incoming traffic:
        - Forwarding the incoming *HTTP* requests on port 80
        - Forwarding the incoming *HTTPS* requests on port 443
    3. Create 2 target groups *(HTTP and HTTPS)* to distribute the load between the targets
    4. Create target group attachments to attach individual instance/node to the desired target group*. In this example the instances are associated as follows:
        - *webserver1* and *webserver2* are associated with *http target group*
        - all 3 instances *(webserver1, webserver2, webserver3)* are associated with *https target group* 

\* *The targets belonging to the same target group, to which requests are forwarded, have to run the same service*

