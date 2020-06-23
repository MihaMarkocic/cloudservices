# Deploy AWS EC2 webserver and S3 static website bucket

This subdirectory/example contains Ansible playbooks/tasks and other configuration files, to deploy a webserver with content from the public bucket. No special attention is given to the creation of custom infrastructure.

### Content:
- *ansible.cfg* and *hosts* are configuration and inventory files (respectively).
- *access_vars* file contains vaulted AWS credentials. However, in this case, access vars are used only to upload created SSH key - mainly to show the use of such authentication method. Otherwise, credentials are set as environment variables. 
- *setup_vars* is the main file containing all the variables used in this example.
- [*deploy_infrastructure*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/deploy_webserver/deploy_infrastructure.yml) is the main playbook, containing multiple tasks to launch and configure EC2 and S3 services. [Tasks](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/deploy_webserver/tasks) are divided into:
    - [EC2](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/deploy_webserver/tasks/ec2) tasks - creating security groups, finding appropriate AMI ID, launching EC2 instance, installing Apache service and uploading new *index.html* file.
    - [S3](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/deploy_webserver/tasks/s3) tasks - launching an S3 bucket, setting the bucket policy and sync folder and turning bucket into a static website.
    - [SSH](https://github.com/MihaMarkocic/cloudservices/tree/master/AWS/deploy_webserver/tasks/ssh) tasks - individual playbooks for SSH key creation and upload to AWS.
- [*destroy_infrastructure*](https://github.com/MihaMarkocic/cloudservices/blob/master/AWS/deploy_webserver/destroy_infrastructure.yml) playbook is used to destroy running EC2 instance, security groups and S3 bucke