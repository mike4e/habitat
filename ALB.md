# AWS ALB (Application Load Balancer)
note: Due to lack of experience with Terraform and AWS, the ALB was defined manually using the AWS console
## generate a self-signed SSL certificate for use with the ALB
```
mike@revo:~/git/mike4e/habitat/cert$  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout privateKey.key -out certificate.crt
Generating a RSA private key
................................................+++++
....................................................................................+++++
writing new private key to 'privateKey.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:UK
State or Province Name (full name) [Some-State]:London
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mike4e
Organizational Unit Name (eg, section) []:habitat
Common Name (e.g. server FQDN or YOUR name) []:mike.forey
Email Address []:mike.forey@gmail.com
mike@revo:~/git/mike4e/habitat/cert$

mike@revo:~/git/mike4e/habitat/cert$ openssl rsa -in privateKey.key -check
RSA key ok

mike@revo:~/git/mike4e/habitat/cert$ openssl x509 -in certificate.crt -text -noout

mike@revo:~/git/mike4e/habitat/cert$ openssl rsa -in privateKey.key -text > private.pem
writing RSA key
mike@revo:~/git/mike4e/habitat/cert$ openssl x509 -inform PEM -in certificate.crt > public.pem
mike@revo:~/git/mike4e/habitat/cert$ ll
total 36
drwxrwxr-x 2 mike mike  4096 Sep 12 10:50 ./
drwxrwxr-x 6 mike mike  4096 Sep 12 10:42 ../
-rw-rw-r-- 1 mike mike  2354 Sep 12 10:49 certificate.crt
-rw------- 1 mike mike  4048 Sep 12 10:48 privateKey.key
-rw-rw-r-- 1 mike mike 13792 Sep 12 10:50 private.pem
-rw-rw-r-- 1 mike mike  2354 Sep 12 10:50 public.pem
mike@revo:~/git/mike4e/habitat/cert$
```

## define a target group for the load balancer

![targets](https://user-images.githubusercontent.com/1073559/132988887-0e2dcfc8-53f6-45e4-88e2-ebe7bea4ec34.png)

```
mike@revo:~$ aws elbv2 describe-target-groups
{
    "TargetGroups": [
        {
            "TargetGroupArn": "arn:aws:elasticloadbalancing:eu-west-2:827289392165:targetgroup/targets/4eb7ddfeb95a99f9",
            "TargetGroupName": "targets",
            "Protocol": "HTTP",
            "Port": 8080,
            "VpcId": "vpc-d06f5cb8",
            "HealthCheckProtocol": "HTTP",
            "HealthCheckPort": "traffic-port",
            "HealthCheckEnabled": true,
            "HealthCheckIntervalSeconds": 30,
            "HealthCheckTimeoutSeconds": 5,
            "HealthyThresholdCount": 5,
            "UnhealthyThresholdCount": 2,
            "HealthCheckPath": "/",
            "Matcher": {
                "HttpCode": "200"
            },
            "LoadBalancerArns": [
                "arn:aws:elasticloadbalancing:eu-west-2:827289392165:loadbalancer/app/balance1/8c8fbf0999ed7ae7"
            ],
            "TargetType": "instance"
        }
    ]
}
mike@revo:~$
```
## define a load balancer
* upload the certificate created above
* listen on 443 and forward to the target group defined above

![balance1](https://user-images.githubusercontent.com/1073559/132988890-7c42463d-386f-4738-909f-b1637e7b665f.png)


```
mike@revo:~$ aws elbv2 describe-load-balancers
{
    "LoadBalancers": [
        {
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:eu-west-2:827289392165:loadbalancer/app/balance1/8c8fbf0999ed7ae7",
            "DNSName": "balance1-1506060314.eu-west-2.elb.amazonaws.com",
            "CanonicalHostedZoneId": "ZHURV8PSTC4K8",
            "CreatedTime": "2021-09-11T21:37:42.220Z",
            "LoadBalancerName": "balance1",
            "Scheme": "internet-facing",
            "VpcId": "vpc-d06f5cb8",
            "State": {
                "Code": "active"
            },
            "Type": "application",
            "AvailabilityZones": [
                {
                    "ZoneName": "eu-west-2a",
                    "SubnetId": "subnet-6411501e",
                    "LoadBalancerAddresses": []
                },
                {
                    "ZoneName": "eu-west-2b",
                    "SubnetId": "subnet-976bffdb",
                    "LoadBalancerAddresses": []
                }
            ],
            "SecurityGroups": [
                "sg-dc0b55a2"
            ],
            "IpAddressType": "ipv4"
        }
    ]
}
```

## test
connecting to this URL round-robins connections to the two webserver when you refresh the browser
* https://balance1-1506060314.eu-west-2.elb.amazonaws.com/
  * note: your browser will complain because it using a self-signed certificate
