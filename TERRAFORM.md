# Terraform
## Setup
### define some variables for use in multiple resources
* the name of the key to be added to the EC2 instances
* the IP of my home system (`revo`) to add to the security group for ssh access
```
mike@revo:~/git/mike4e/habitat$ cat terraform/ec2-instance/variables.tf
variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "key_name" {
  type    = string
  default = "mikey"
}

variable "revo_ip" {
  type = string
  default = "109.152.206.183"
}
```
### define the EC2 instances resources that we want to build
* grab the AMI id for a Ubuntu image from the AWS console
```
mike@revo:~/git/mike4e/habitat$ cat terraform/ec2-instance/ec2_server1.tf
resource "aws_instance" "ec2_server1" {
  ami           = "ami-0194c3e07668a7e36"
  instance_type = "t2.micro"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_habitat.id]

  tags = {
    Name = "ec2_server1"
  }
}
mike@revo:~/git/mike4e/habitat$ cat terraform/ec2-instance/ec2_server2.tf
resource "aws_instance" "ec2_server2" {
  ami           = "ami-0194c3e07668a7e36"
  instance_type = "t2.micro"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_habitat.id]

  tags = {
    Name = "ec2_server2"
  }
}
``` 
### define the security group 
* allow ssh access from home and port 8080 from anywhere
```
mike@revo:~/git/mike4e/habitat$ cat terraform/ec2-instance/sg_habitat.tf
resource "aws_security_group" "sg_habitat" {
  name        = "sg_habitat"
  description = "controls access to the EC2 instance"
}

...

resource "aws_security_group_rule" "http_http" {
  security_group_id = aws_security_group.sg_habitat.id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.sg_habitat.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.revo_ip}/32"]

}

```
### define some Terraform outputs so we can see the details of our instances 
```
mike@revo:~/git/mike4e/habitat$ cat terraform/ec2-instance/outputs.tf
output "ec2_server1_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2_server1.id
}

output "ec2_server1_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2_server1.public_ip
}

output "ec2_server1_instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.ec2_server1.public_dns
}

output "ec2_server2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2_server2.id
}

output "ec2_server2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2_server2.public_ip
}

output "ec2_server2_instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.ec2_server2.public_dns
}
mike@revo:~/git/mike4e/habitat$
```
## Apply

### init
```
mike@revo:~/git/mike4e/habitat/terraform/ec2-instance$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 3.27"...
- Installing hashicorp/aws v3.58.0...
- Installed hashicorp/aws v3.58.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
mike@revo:~/git/mike4e/habitat/terraform/ec2-instance$
```

### plan
```
mike@revo:~/git/mike4e/habitat/terraform/ec2-instance$ terraform plan
...
```
### apply
```
mike@revo:~/git/mike4e/habitat/terraform/ec2-instance$ terraform apply
...

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

ec2_server1_instance_id = "i-042dc038f17597d52"
ec2_server1_instance_public_dns = "ec2-3-8-136-28.eu-west-2.compute.amazonaws.com"
ec2_server1_instance_public_ip = "3.8.136.28"
ec2_server2_instance_id = "i-06493a327adbfc81b"
ec2_server2_instance_public_dns = "ec2-52-56-201-248.eu-west-2.compute.amazonaws.com"
ec2_server2_instance_public_ip = "52.56.201.248"
mike@revo:~/git/mike4e/habitat/terraform/ec2-instance$
```
### check on AWS
```
mike@revo:~/git/mike4e/habitat/terraform$ aws ec2 describe-instances | grep Public
                    "PublicDnsName": "ec2-52-56-201-248.eu-west-2.compute.amazonaws.com",
                    "PublicIpAddress": "52.56.201.248",
                                "PublicDnsName": "ec2-52-56-201-248.eu-west-2.compute.amazonaws.com",
                                "PublicIp": "52.56.201.248"
                                        "PublicDnsName": "ec2-52-56-201-248.eu-west-2.compute.amazonaws.com",
                                        "PublicIp": "52.56.201.248"
                    "PublicDnsName": "ec2-3-8-136-28.eu-west-2.compute.amazonaws.com",
                    "PublicIpAddress": "3.8.136.28",
                                "PublicDnsName": "ec2-3-8-136-28.eu-west-2.compute.amazonaws.com",
                                "PublicIp": "3.8.136.28"
                                        "PublicDnsName": "ec2-3-8-136-28.eu-west-2.compute.amazonaws.com",
                                        "PublicIp": "3.8.136.28"
mike@revo:~/git/mike4e/habitat/terraform$
```
### login and check the hosts
```
mike@revo:~$ ssh ubuntu@ec2-52-56-201-248.eu-west-2.compute.amazonaws.com
Enter passphrase for key '/home/mike/.ssh/id_rsa':
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-1045-aws x86_64)

ubuntu@ip-172-31-17-200:~$ uname -a
Linux ip-172-31-17-200 5.4.0-1045-aws #47-Ubuntu SMP Tue Apr 13 07:02:25 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
ubuntu@ip-172-31-17-200:~$
```

```
mike@revo:~$ ssh ubuntu@ec2-3-8-136-28.eu-west-2.compute.amazonaws.com
Enter passphrase for key '/home/mike/.ssh/id_rsa':
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-1045-aws x86_64)

ubuntu@ip-172-31-26-92:~$ uname -a
Linux ip-172-31-26-92 5.4.0-1045-aws #47-Ubuntu SMP Tue Apr 13 07:02:25 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
ubuntu@ip-172-31-26-92:~$
```

## next

configure the webserver with [Ansible](/ANSIBLE.md)

