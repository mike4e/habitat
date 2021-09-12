# habitat
Terraform and Ansible testing with AWS

## Objective
The objective is to design and deploy a Production ready web service in AWS with the following criteria:
* The web service must be highly available
* Be able to hit a sample web page from the web service deployed using HTTPS port 443 and redirected to port 8080
* For provisioning use Terraform and deployment tool use Ansible
* OS – Ubuntu or Centos

## High Level Plan
* use Terraform to provision multiple Ubuntu EC2 instances
* use Ansible to configure a web server/application on these instances, listening on port 8080
* setup an AWS ALB listening on port 443 and balancing the traffic to the servers on port 8080

## Points to consider 
* Monitoring and maintainability
   * investigate using CloudWatch to monitor the service/servers
* Capacity and growth
   * provision more servers!
   * investigate EC2 Auto Scaling 
   * using Beanstalk might be a simpler way to deploy a scalable web application
* Deploying to a Production environment that has VMs already running.

## Notes
* `revo` is the local host that I am driving the work from

## Prerequisites
* a public key (`mikey`) has been added via the AWS console
* terraform has been installed on `revo`
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
* the aws cli has been installed and configured 
```
mike@revo:~$ cat ~/.aws/config
[default]
region = eu-west-2
output = json
mike@revo:~$ cat ~/.aws/credentials
[default]
aws_access_key_id = <private>
aws_secret_access_key = <private>
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
### Terraform - provision the EC2 hosts
 *  [Terraform](/TERRAFORM.md)
### Ansible - configure the web server and application
 *  [Ansible](/ANSIBLE.md)
### ALB - configured manually
 *  [ALB](/ALB.md)
## Gotchas
* login to the Ubuntu instances with "ubuntu" used not "ec2-user"
* terraform was not able change the description of a security group
   * terraform  to remove the sg but as it was in use it just times out and never does anything
## Resources
* https://docs.aws.amazon.com/cli/latest/reference/
* https://learn.hashicorp.com/tutorials/terraform/aws-build
* https://towardsaws.com/high-availability-lamp-in-aws-with-terraform-and-ansible-b9b09c66d1a9
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
* https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-apache-on-ubuntu-18-04
* https://medium.com/@francisyzy/create-aws-elb-with-self-signed-ssl-cert-cd1c352331f
