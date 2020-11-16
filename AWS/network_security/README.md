# Network Security deployment Example
In this example, different AWS network security measures are deployed to demonstrate how to secure your instances in public/private subnet with security groups, custom network ACL and monitor the traffic with AWS Flow Logs. 
**This demo serves a demonstrating purpose how to create AWS security groups, custom NACLs and Flow Logs with Terraform and is not in any way an indication how the specific security rules of inbound and outbound traffic should be configured!!**

## Details
In this demo, two (private & public) subnets are created in a custom VPC. An instance is deployed in each subnet, secured with an appropriate Security Group. A Public subnet is additionally secured with a custom NACL. *Flow Logs* are used to monitor the traffic in public and private subnet and are stored in S3 bucket.

[*main.tf*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/network_security/main.tf) is the main Terraform file, where provisioner is defined and different modules are used/executed:

- [Storage](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/network_security/modules/storage):
    1. Create an S3 bucket for the storage of the Flow Logs

- [Network infrastructure & security](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/network_security/modules/network):
    1. Create a new VPC *(172.19.0.0/17)*
    2. Create one public *(172.19.1.0/24)* and one private *(172.19.2.0/24)* subnet
    3. Create public SG *(HTTP, HTTPS and SSH\* from anywhere; HTTP, HTTPS to anywhere and MySQL to private subnet)*
    4. Create private SG *(SSH and MySQL from public subnet; HTTP, HTTPS to anywhere)*
    5. Create custom Network Access Control List (NACL) allowing:
        - inbound traffic from *HTTP, HTTPS, SSH and ephemeral ports\** *
        - outbound traffic on *HTTP, HTTPS, MySQL and ephemeral ports\** * 
    6. Create Flow Logs and store them into the S3 bucket:
        - Monitoring ALL traffic for the public subnet
        - Monitoring ACCEPTED traffic for the private subnet

- [EC2 instances deployment](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/network_security/modules/compute):
    1. Obtain AWS AMI ID for the desired os *(Ubuntu Server 18.04 LTS from Canonical)*
    2. Deploy 1 server instance in a created public subnet, and associate it with public Security Group
    3. Deploy 1 server instance in a created private subnet, and associate it with private Security Group    

\*  *SSH traffic to your subnet should be allowed only from your IP address or IP address range*

\** *Unlike security groups, where the rules are stateful (respond to the request sent from your instance is allowed to flow in regardless of the inbound rules), Network ACLs are stateless! This means the responses to allowed inbound traffic are subject to the rules for outbound traffic (and vice versa). Because of that, the ephemeral ports with an appropriate TCP port ranges are included in inbound and outbound traffic rules*

