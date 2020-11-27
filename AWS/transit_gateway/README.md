# AWS Transit Gateway Example
In this example a transit gateway is used to interconnect Virtual Private CLouds (VPCs) in the same region. Such configuration is also known as *a centralized router*. A transit gateway acts as a  regional virtual router for traffic between your VPCs and VPN connections. Such routing operates at layer 3, where packets are sent to the next-hop attachment based on their destination.

## Details
This demo consists of two VPCs, both deployed in the same region (*eu-west-2*). Within each VPC, there are two subnets, to which custom route table and internet gateway is attached. Apart from default route allowing the traffic flowing between subnets in the same VPC, additional routes are configured allowing traffic to the internet through internet gateway and to other VPC through transit gateway. Each subnet consists of one webserver instance used to test the transit gateway connection between the VPCs/subnets.

[*main.tf*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/transit_gateway/main.tf) is the main Terraform file with defined region, provider, outputs and modules used to create transit gateway between VPCs. Network infrastructure (creation of VPCs, subnets, route tables, internet gateways and routes) was done in the Network module. Compute module was used twice - reusing the file to create instance in two subnets of the defined VPC. Seperated in Transit module is the creation of transit gateway connecting both VPCs by attaching them to the transit gateway and setting the routes pointing in the direction of the other VPC. 

Modules subdirectory consist of:

- [Network](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/transit_gateway/modules/network):
    1. Create VPC A (*172.19.0.0/16*) and VPC B (*172.20.0.0/16*) in the same region.
    2. Create 2 subnets (*172.19.1.0/24 & 172.19.2.0/24*) in VPC A and 2 subnets (*172.20.1.0/24 & 172.20.2.0/24*) in VPC B. All four subnets are set to be public.
    4. Create security groups for public instances:
        - in VPC A *(SSH\* allowed from anywhere, HTTP allowed from both VPCs, ICMP ping allowed from both VPCs; all outbound traffic allowed)*
        - in VPC B *(SSH\* allowed from anywhere, HTTP allowed from both VPCs, ICMP ping allowed from both VPCs; all outbound traffic allowed)*
    5. Create internet gateway and route table in VPC A and B. Within each VPC associate both subnets to the route table and set the routes: 
        - routing the packects going to *(0.0.0.0/0)* through internet gateway
        - routing the packets going to the other VPC through transit gateway 

- [Transit](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/transit_gateway/modules/transit):
    1. Create Transit gateway with default route table connecting VPC A and VPC B.
    2. Attach VPC A with its subnets to the transit gateway and its default route table.
    3. Attach VPC B with its subnets to the transit gateway and its default route table.
    4. Define transit gateway route in default route table pointing to VPC A.
    5. Define transit gateway route in default route table pointing to VPC B.

- [Compute](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/transit_gateway/modules/compute):
    1. Obtain AWS AMI ID for the desired os *(Ubuntu Server 18.04 LTS from Canonical)* in a defined region
    2. Deploy 1 server instance in a created subnet 1
        - associate it with the custom security group
        - through "remote-exec" provisioner install apache2 service
    3. Deploy 1 server instance in a created subnet 2
        - associate it with the custom security group
        - through "remote-exec" provisioner install apache2 service    


## Testing the connection
Apart from Terraform files and modules to build the VPC peering infrastructure, this repository includes also a short *Ansible Playbook* [*connection_test*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/transit_gateway/connection_test.yml) to test the transit gateway connecting the instances in different VPCs. In order to gather the hosts (webservers) deployed with Terraform, an [*aws_ec2*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/transit_gateway/aws_ec2.yml) plugin is used to create dynamic inventory. Once the infrastructure is deployed, you can inspect what is the output of *aws_ec2* plugin by executing the following command in the terminal:
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

As mentioned the Ansible playbook connects over SSH to each instance deployed and tries to reach other instances over privte IPs on port 80. For that purpose, the security group of webservers allows only SSH inbound traffic from "outside", while HTTP traffic is allowed from within both VPCs. If there are no errors during the deployment, the playbook should succesfully finish with all connections tested.


\*  *SSH traffic to your subnet should be allowed only from your IP address or IP address range*


