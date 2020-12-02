# IP Multicast with AWS Transit Gateway
Multicast is a communication protocol used to deliver a single stream of data to multiple receiving instances simultaneously. This means a source host can send a single packet to multiple receiving hosts at the same time. In AWS, transit gateway supports multicast traffic between subnets of VPCs attached to it and serves as a multicast router. Before deploying multicast routing make sure your region of choice supports multicast over transit gateway. Further, with existing transit gateways multicast can not be enabled. Instead, a new transit gateway must be deployed. Multicast settings are managed using Amazon VPC console or AWS CLI! There is no support yet for managing transit gateway multicast with Terraform or Ansible!  

## Details
This demo consists of two VPCs created in the same region, each having one public subnet.The subnet in *VPC A* has only one instance as it is set to be the source of multicast. On the other side, subnet in VPC B consists of 2 instances both on the receiving side of the multicast group. 2 instances are enough to test the multicast stream of data. It should be mentioned that the source and receiving instances can also be within the same VPC and/or subnet. Multicast communication is tested with *iPerf* command. To be able to login to the instance over SSH, install apache webserver and send multicast UDP packets, a custom security group is created. Further, to access the instance from the internet a simple custom route table and internet gateway is provided, while the multicast is done through a custom transit gateway, as mentioned.

[*main.tf*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/ip_multicast/main.tf) is the main Terraform file with the defined region, provider, outputs and modules used to create multicast communication with transit gateway. Network infrastructure (creation of VPCs, subnets, route tables, internet gateways and routes) was done in the Network module which was used twice - once per VPC. Compute module which consists of creating an instance and installing appropriate software through remote provisioner was used three times - to create one instance in VPC A and two instances in VPC B. As Terraform does not have support for transit gateway multicast, a part of transit gateway setup was moved to the AWS CLI. Therefore the Transit module is responsible to get the ID of transit gateway created with AWS CLI and attach VPCs with their subnets to that transit gateway. This file also outputs some of the infrastructure IDs which are crucial for the creation of transit gateway multicast domains and associations later in the AWS CLI. 

Steps to deploy this infrastructure with AWS CLI and Terraform combined are explained below under *"Deployment steps"* section.

### Modules
- [Network](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/ip_multicast/modules/network):
    1. Create a VPC in the defined region:
        - VPC A *(10.0.0.0/16)*
        - VPC B *(10.10.0.0/16)*
    2. Create one public subnet in each VPC.
    3. Create an internet gateway, route table and associate it with the subnet. Add a public route for instances to have access to the internet through the internet gateway.
    4. Create a custom security group in each VPC, allowing SSH and UDP inbound traffic and any outbound traffic: *(SSH\*  on port 22 allowed from anywhere, UDP on port 5001 allowed from anywhere; all outbound traffic allowed)*.
        
- [Transit](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/ip_multicast/modules/transit):
    1. get the ID of the transit gateway created with AWS CLI. Filtering the results by:
        - The amazon side ANS number (set to default)
        - The state of the transit gateway (*available* or *pending*) 
        - The name tag of the transit gateway *(should match the tag name used in AWS CLI)*
    2. Attach VPC A with its subnet to the transit gateway and its default route table.
    3. Attach VPC B with its subnet to the transit gateway and its default route table.

- [Compute](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/ip_multicast/modules/compute):
    1. Obtain AWS AMI ID for the desired os *(Ubuntu Server 18.04 LTS from Canonical)* in a defined region
    2. Deploy one server instance in a selected VPC/subnet and
        - choose the right instance type\**!
        - associate it with the custom security group
        - through "remote-exec" provisioner install apache2 service
     
\*  *SSH traffic to your subnet should be allowed only from your IP address or IP address range*

\** *Only **AWS Nitro** instances can be used as a multicast source! Using non-Nitro instance as a multicast receiver requires disabling the Source/Dest check!*

## Deployment steps 
This section provides a detailed description of the steps needed to create described "multicast over transit gateway" infrastructure. Nevertheless, it is assumed that the individual has the basic setup/environment configured (Terraform and AWS CLI), a basic understanding of the tools, how to use them and an active subscription/access to the AWS services.

1. From the terminal set the AWS CLI profile and make sure that the default region matches your wishes and the settings in the Terraform files (in this demo the *"eu-west-2"* region is used). You can set the default region in AWS CLI with command
    ```
    aws configure
    ```
    If you have set your profile and want to change just the region you can set it with
    ```
    aws configure set default.region *region*
    ```
2. Using AWS CLI create the [transit gateway](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-transit-gateway.html). Enable auto-accepting of shared attachments, default route table association and propagation, DNS support and most importantly **Multicast support** and set the name tag to "Multicast-TG" with   
    ```
    aws ec2 create-transit-gateway \
    --description "transit gateway with multicast enabled" \
    --options AutoAcceptSharedAttachments=enable,DefaultRouteTableAssociation=enable,DefaultRouteTablePropagation=enable,DnsSupport=enable,MulticastSupport=enable \
    --tag-specifications 'ResourceType=transit-gateway,Tags=[{Key=Name,Value=Multicast-TG}]'
    ```
    To get the information about deployed transit gateways and their status send command
    ```
    aws ec2 describe-transit-gateways
    ```
3. Move to the cloned git repo where the *main.tf* file is and initialize Terraform with `terraform init` command and then deploy the infrastructure with `terraform plan` and `terraform apply` commands. It is crucial to run the terraform deployment of infrastructure after you created the multicast-enabled transit gateway. The outputs of AWS infrastructure (transit-gateway ID, subnet IDs, instance NIC IDs, etc.) needed for further configuration will be displayed after a successful deployment.
4. After the Terraform successfully deploys the infrastructure and provision the instances move to the AWS CLI console and create a transit gateway[multicast domain](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-transit-gateway-multicast-domain.html). Use the following command to create it, where the transit gateway ID should be replaced with the one created.
    ```
    aws ec2 create-transit-gateway-multicast-domain \
    --transit-gateway-id *tg-12345*
    ```
    Before you proceed with the next step make sure that the multicast domain is up and running:
    ```
    aws ec2 describe-transit-gateway-multicast-domains
    ```
    Make sure to save the multicast domain ID, as it will be needed in the following steps!
5. After the transit gateway multicast domain is up and running, [associate the VPC/subnet attachments](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/associate-transit-gateway-multicast-domain.html) (created with Terraform) with the multicast domain. For this step a *multicast domain ID*, *transit gateway VPC attachment ID* and *subnet ID* will be needed
    ```
    aws ec2 associate-transit-gateway-multicast-domain \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --transit-gateway-attachment-id tgw-attach-12345 \
    --subnet-id subnet-12345
    ```
    Repeat this step for all the subnets you wish to associate with the multicast domain!
6. The only thing missing after the association is the registration of multicast group [members](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/register-transit-gateway-multicast-group-members.html) and [sources](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/register-transit-gateway-multicast-group-sources.html).
to register the members (receivers) the *network interface card IDs* of instances as well *multicast domain ID* will be needed. Further, the IP of the multicast group should be set  
    ```
    aws ec2 register-transit-gateway-multicast-group-members \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --group-ip-address 239.0.0.1 \
    --network-interface-ids eni-1234 eni-12345
    ```
    The same step with a slightly different command but same multicast IP address must be repeated for the sources
    ```
    aws ec2 register-transit-gateway-multicast-group-sources \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345]
    --group-ip-address 239.0.0.1 \
    --network-interface-ids eni-1234 eni-12345
    ```
With this, the deployment of the AWS transit gateway multicast demo is completed!

## Testing the multicast group
After the setup is complete it is time to test it. In this demo, the use of [iPerf](https://iperf.fr/) tool for testing is described. *iPerf* should be installed on source and receiver instances. Connect to the Ubuntu Linux based instances over SSH and install the tool with `sudo apt-get install iperf`. Notice that the custom security group created allows the UDP transport protocol on port 5001 which is the default port used by iPerf.
After the installation on all instances, go to the multicast receiver instances and set them in server mode for the multicast group *239.0.0.1* (IP address set in step 6 of deployment) using UDP:
```
iperf -s -u -B 239.0.0.1 -i 1
```
This way the iPerf recognizes the multicast IP address and waits for the incoming UDP traffic on port 5001.
The only thing left is for the source to send the traffic to the multicast IP address. On the multicast source instance, start the iPerf in client mode against the same multicast group.
```
iperf -c 239.0.0.1 -u -T 32 -t 3 -i 1
```
The traffic will be generated and sent to the multicast group 239.0.0.1 over UDP to port 5001. While this is happening you can switch back to the receiving multicast instances that are waiting for the traffic and check that the traffic is received at the same time.

## Destroying the infrastructure
Some attention should be given also when destroying the instances. When deploying with Terraform only, the tool itself takes care of dependencies. However, in this case, transit-gateway and multicast domains were deployed by AWS CLI. As there are some dependencies between resources deployed with Terraform and resources deployed with AWS CLI a special order of "destruction" should be used. In these steps, the IDs that were used when creating resources will be needed again!
1. Deregister sources and group members:
    ``` 
    aws ec2 deregister-transit-gateway-multicast-group-sources \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --group-ip-address 239.0.0.1 \
    --network-interface-ids eni-1234 eni-12345

    aws ec2 deregister-transit-gateway-multicast-group-members \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --group-ip-address 239.0.0.1 \
    --network-interface-ids eni-1234 eni-12345
    ```
2. Disassociate VPC/subnet attachments from transit gateway domain. Repeat this step for each association (each subnet)
    ```
    aws ec2 disassociate-transit-gateway-multicast-domain \
    --transit-gateway-multicast-domain-id tgw-mcast-domain-12345 \
    --transit-gateway-attachment-id tgw-attach-12345 \
    --subnet-id subnet-12345
    ```
3. Delete the transit gateway multicast domain.
    ```
    aws ec2 delete-transit-gateway-multicast-domain --transit-gateway-multicast-domain-id tgw-mcast-domain-12345
    ```
4. Destroy the infrastructure/resources created with Terraform using `terraform destroy`. By this time, no associations to AWS CLI created resources should remain.
5. Finally, delete the transit gateway.
    ```
    aws ec2 delete-transit-gateway --transit-gateway-id tgw-12345
    ```

