# VPC peering Example
In this example, the VPC peering connection is established between two VPCs in different regions - also known as *inter-region VPC peering connection*. Peering is a networking connection between two VPCs that enables you to route the traffic between them using private IPv4 and/or IPv6 addresses. With such connection instances in either VPC can communicate with each other as if they are in the same network. 

## Details
This demo consists of two VPCs, each deployed in a different region (*eu-west-2 and eu-west-3*). Within each VPC, there are two subnets, to which custom route table and internet gateway are attached. Apart from enabling subnets to access the internet through the gateway, additional peering routes are configured through peering connection for subnets to access the VPC in another region. Each subnet consists of one webserver instance used to test the VPC peering connection.

[*main.tf*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/vpc_peering/main.tf) is the main Terraform file with general variables, outputs and modules used to create VPC peering. As the infrastructure for the inter-region peering requires resources to be created within different regions, the provider was specified within each module! By inspecting the *main.tf* file you can see, that same module was used twice - each time for a different region. This way, the unnecessary writing of the same scripts deploying exactly the same infrastructure for different regions was avoided. The exception was peering module, where unique peering connection and routes specific for the region had to be configured. 

Modules subdirectory consist of:

- [Network](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/vpc_peering/modules/network):
    1. Define the region where network infrastructure should be deployed! 
    2. Create a VPC 
    3. Create two public subnets
    4. Create an internet gateway and a route table. associate both subnets with the route table to enabling access to the internet
    5. Create custom Security group *(SSH\* from anywhere, HTTP from both VPCs; all outbound traffic allowed)* 

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

## Testing the connection
Apart from Terraform files and modules to build the VPC peering infrastructure, this repository includes also a short *Ansible Playbook* [*connection_test*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/vpc_peering/connection_test.yml) to test the VPC peering connections between instances. In order to gather the hosts (webservers) deployed with Terraform, an [*aws_ec2*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/vpc_peering/aws_ec2.yml) plugin is used to create dynamic inventory. Once the infrastructure is deployed, you can inspect what is the output of *aws_ec2* plugin by executing the following command in the terminal:
```
ansible-inventory -i aws_ec2.yml --list --yaml
```

Ansible playbook is executed on all 4 hosts (webservers) simultaneously, testing the connection to other instances over the private IPs on port 80. To run *connection_test* the following commands should be executed from the terminal:

- Ansible enables host key checking by default, which guards against spoofing and man-in-the-middle attacks! If a new host is not in *'known_hosts'* your control may prompt for confirmation. If you do not want this and understand the implications you can *disable host key checking* by setting an environment variable:
    ```
    export ANSIBLE_HOST_KEY_CHECKING=False
    ```

    or by changing/editing the settings in *ansible.cfg* file:
    ```
    [defaults]
    host_key_checking = False
    ```
- the command to run the ansible playbook should include the *username* to log in to each instance, *Key location* for the SSH connection and *inventory file* which is in our case *aws_ec2* plugin and the playbook file:
    ```
    ansible-playbook -u *username* --private-key *path/to/your/sshkey* -i aws_ec2.yml connection_test.yml
    ```



\*  *SSH traffic to your subnet should be allowed only from your IP address or IP address range*


