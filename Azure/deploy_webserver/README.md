# Deploy Azure webserver and Azure storage account

This subdirectory/example contains Ansible playbooks/tasks and other configuration files, to deploy a webserver with content from the public storage account. Minimal attention is given to the creation of custom infrastructure - Vnet and a subnet.

### Content:
- *ansible.cfg* and *hosts* are configuration and inventory files (respectively).
- *setup_vars* is the main file containing all the variables used in this example.
- [*deploy_infrastructure*](https://github.com/MihaMarkocic/cloudservices/blob/master/Azure/deploy_webserver/deploy_infrastructure.yml) is the main playbook, containing multiple tasks to launch and configure Azure VM as a webserver and a Storage as a static website. [Tasks](https://github.com/MihaMarkocic/cloudservices/tree/master/Azure/deploy_webserver/tasks) are divided into:
    - [Network](https://github.com/MihaMarkocic/cloudservices/tree/master/Azure/deploy_webserver/tasks/network) tasks - creating a resource group, a simple Vnet and a public subnet. 
    - [VM](https://github.com/MihaMarkocic/cloudservices/tree/master/Azure/deploy_webserver/tasks/vm) tasks - launching instance, setting security rules for VM security group, installing Apache service and uploading new *index.html* file.
    - [Storage](https://github.com/MihaMarkocic/cloudservices/tree/master/Azure/deploy_webserver/tasks/storage) tasks - creating blob storage and uploading files.
- [*delete_rg*](https://github.com/MihaMarkocic/cloudservices/blob/master/Azure/deploy_webserver/delete_rg.yml) playbook is used to destroy created resource group and with it everything that was created/spawned in it (Vnet, subnet, virtual machine and storage account). 

