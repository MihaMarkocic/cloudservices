# VPC peering Example
In this example, the VPC peering connection is established between two VPCs in different regions - also known as *inter-region VPC peering connection*. Peering is a networking connection between two VPCs that enables you to route the traffic between them using private IPv4 and/or IPv6 addresses. With such connection instances in either VPC can communicate with each other as if they are in the same network. 

## Details
This demo consists of two VPCs, each deployed in a different region (*eu-west-2 and eu-west-3*). Within each VPC, there are two subnets, to which custom route table and internet gateway are attached. Apart from enabling subnets to access the internet through the gateway, additional peering routes are configured through peering connection for subnets to access the VPC in another region. Each subnet consists of one webserver instance used to test the VPC peering connection.

[*main.tf*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/network_security/main.tf) is the main Terraform file with general variables, outputs and modules used to create VPC peering. As the infrastructure for the inter-region peering requires resources to be created within different regions, the provider was specified within each module! By inspecting the *main.tf* file you can see, that same module was used twice - each time for a different region. This way, the unnecessary writing of the same scripts deploying exactly the same infrastructure for different regions was avoided. The exception was peering module, where unique peering connection and routes specific for the region had to be configured. 

Modules subdirectory consist of:

- [Network](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/vpc_peering/modules/network):
    1. Define the region where network infrastructure should be deployed! 
    2. Create a VPC 
    3. Create two public subnets
    4. Create an internet gateway and a route table. associate both subnets with the route table to enabling access to the internet
    5. Create custom Security group *(SSH\* from anywhere, HTTP form both VPCs; all outbound traffic allowed)* 

- [Peering](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/vpc_peering/modules/peering):
    1. Define both AWS regions used as they are needed to create a connection on both "sides"
    2. Create requester's side of peering connection between two VPCs
    3. Create the accepter's side of peering connection to accept it.
    4. Define peering route on the requester's route table pointing to accepter's VPC CIDR block
    5. Vice versa - route on the accepter's route table pointing to requester's VPC CIDR block

- [Compute](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/vpc_peering/modules/compute):
    1. Obtain AWS AMI ID for the desired os *(Ubuntu Server 18.04 LTS from Canonical)* in a defined region
    2. Deploy 1 server instance in a created subnet A
        - associate it with the custom security group
        - through "remote-exec" provisioner install apache2 service
    3. Deploy 1 server instance in a created subnet B
        - associate it with the custom security group
        - through "remote-exec" provisioner install apache2 service    

By connecting over SSH to the instance of choice you can test the VPC peering connection by trying to reach other instances (in the other VPC) by using their private IP addresses. For the purpose of testing, security group was customized to allow the HTTP traffic only from created VPCs. SSH is the only traffic an instance can accept from the "outside" network.

\*  *SSH traffic to your subnet should be allowed only from your IP address or IP address range*


