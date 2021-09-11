# habitat
Terraform and Ansible testing with AWS
## Objective
The objective is to design and deploy a Production ready web service in AWS with the following criteria:
* The web service must be highly available
* Be able to hit a sample web page from the web service deployed using HTTPS port 443 and redirected to port 8080
* For provisioning use Terraform and deployment tool use Ansible
* OS – Ubuntu or Centos

## High Level Plan
* use Terraform to provision multiple hosts, either using multiple EC2 instances or Beanstalk (which may provide auto-scaling)
* Use ALB to load balance, as configured either separatelly or as part of Beanstalk
* use Ansible to configure a web server/application on the instances provisioned by Terraform

## Points to consider (TBD)
* Monitoring and maintainability
* Capacity and growth
* Deploying to a Production environment that has VMs already running.

