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
* Use ALB to load balance, configured either as part of Beanstalk, or separately with Terraform
* use Ansible to configure a web server/application on the instances provisioned by Terraform

## Points to consider (TBD)
* Monitoring and maintainability
   * CloudWatch
* Capacity and growth
   * using Beanstalk might be a better way to provide a simple way to scale a web application
* Deploying to a Production environment that has VMs already running.

## Notes
* `revo` is the local host that I am driving the work from

## Prerequisites
* public key to assign to the EC2 instances has been installed on AWS
* terraform on `revo`
```
mike@revo:~$ terraform -v
Terraform v1.0.6
on linux_amd64
mike@revo:~$
```
* aws cli on `revo`
```
mike@revo:~$ aws --version
aws-cli/1.18.69 Python/3.8.10 Linux/5.4.0-84-generic botocore/1.16.19
mike@revo:~$
```
* aws cli configured and ready
```
mike@revo:~$ cat ~/.aws/config
[default]
region = eu-west-2
output = json
mike@revo:~$ cat ~/.aws/credentials
[default]
aws_access_key_id = ******************
aws_secret_access_key = *************************************
mike@revo:~$
mike@revo:~$ aws iam list-users
{
    "Users": [
        {
            "Path": "/",
            "UserName": "mike",
            "UserId": "AIDA4BHSKKQS4M4SKZI5Y",
            "Arn": "arn:aws:iam::827289392165:user/mike",
            "CreateDate": "2021-09-11T12:16:49Z"
        }
    ]
}
mike@revo:~$
```

## Action
### Terrform - provision the hosts and load balancer
### Ansible - configure the application
## Gotchas
* login to the Ubuntu instances with "ubuntu" used not "ec2-user"
* terrform was not able change the description of a security group
   * it tries to remove the sg but if in use it just times out
## RFE
* application monitoring
* scaling
## Resources
