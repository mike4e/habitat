# Ansible
## Setup
### setup some variables 
* define the default port to listen on
```
mike@revo:~/git/mike4e/habitat$ cat ansible/apache/vars/default.yml
---
app_user: "www-data"
http_conf: "habitat.conf"
http_port: "8080"
disable_default: true
mike@revo:~/git/mike4e/habitat$
```
* create a template ports file and a task to the playbook to change the default apache port
```
mike@revo:~/git/mike4e/habitat$ cat ansible/apache/files/ports.conf.j2
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen {{ http_port }}

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

mike@revo:~/git/mike4e/habitat$
mike@revo:~/git/mike4e/habitat$ less ansible/apache/playbook.yml
...

    - name: Configure Apache to listen on {{ http_port }}
      template:
        src: "files/ports.conf.j2"
        dest: "/etc/apache2/ports.conf"
...
```
### define the ansible hosts
```
mike@revo:~/git/mike4e/habitat$ tail -3 /etc/ansible/hosts
[habitat]
ec2_server1 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_host=ec2-3-8-136-28.eu-west-2.compute.amazonaws.com
ec2_server2 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_host=ec2-52-56-201-248.eu-west-2.compute.amazonaws.com
mike@revo:~/git/mike4e/habitat$
```
## go
### ec2_server1

```
mike@revo:~/git/mike4e/habitat/ansible/apache$ ansible-playbook playbook.yml -l ec2_server1 --check
...
mike@revo:~/git/mike4e/habitat/ansible/apache$ ansible-playbook playbook.yml -l ec2_server1

PLAY [all] ********************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [ec2_server1]

TASK [Install prerequisites] **************************************************************************************************************************************************************************************
ok: [ec2_server1] => (item=aptitude)

TASK [Install Apache] *********************************************************************************************************************************************************************************************
ok: [ec2_server1]

TASK [Create document root] ***************************************************************************************************************************************************************************************
ok: [ec2_server1]

TASK [Copy index test page] ***************************************************************************************************************************************************************************************
ok: [ec2_server1]

TASK [Set up Apache virtualhost] **********************************************************************************************************************************************************************************
ok: [ec2_server1]

TASK [Configure Apache to listen on 8080] *************************************************************************************************************************************************************************
ok: [ec2_server1]

TASK [Enable new site] ********************************************************************************************************************************************************************************************
changed: [ec2_server1]

TASK [Disable default Apache site] ********************************************************************************************************************************************************************************
changed: [ec2_server1]

TASK [UFW - Allow HTTP on port 8080] ******************************************************************************************************************************************************************************
ok: [ec2_server1]

RUNNING HANDLER [Reload Apache] ***********************************************************************************************************************************************************************************
changed: [ec2_server1]

PLAY RECAP ********************************************************************************************************************************************************************************************************
ec2_server1                : ok=11   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

mike@revo:~/git/mike4e/habitat/ansible/apache$
```

### ec2_server2

```
mike@revo:~/git/mike4e/habitat/ansible/apache$ ansible-playbook playbook.yml -l ec2_server2 --check
...
mike@revo:~/git/mike4e/habitat/ansible/apache$ ansible-playbook playbook.yml -l ec2_server2

PLAY [all] ********************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [ec2_server2]

TASK [Install prerequisites] **************************************************************************************************************************************************************************************
ok: [ec2_server2] => (item=aptitude)

TASK [Install Apache] *********************************************************************************************************************************************************************************************
ok: [ec2_server2]

TASK [Create document root] ***************************************************************************************************************************************************************************************
ok: [ec2_server2]

TASK [Copy index test page] ***************************************************************************************************************************************************************************************
ok: [ec2_server2]

TASK [Set up Apache virtualhost] **********************************************************************************************************************************************************************************
ok: [ec2_server2]

TASK [Configure Apache to listen on 8080] *************************************************************************************************************************************************************************
ok: [ec2_server2]

TASK [Enable new site] ********************************************************************************************************************************************************************************************
changed: [ec2_server2]

TASK [Disable default Apache site] ********************************************************************************************************************************************************************************
changed: [ec2_server2]

TASK [UFW - Allow HTTP on port 8080] ******************************************************************************************************************************************************************************
ok: [ec2_server2]

RUNNING HANDLER [Reload Apache] ***********************************************************************************************************************************************************************************
changed: [ec2_server2]

PLAY RECAP ********************************************************************************************************************************************************************************************************
ec2_server2                : ok=11   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

mike@revo:~/git/mike4e/habitat/ansible/apache$
```
## check
### ec2_server1

```
mike@revo:~/git/mike4e/habitat/ansible/apache$ ssh ubuntu@ec2-3-8-136-28.eu-west-2.compute.amazonaws.com "ss -tln"
Enter passphrase for key '/home/mike/.ssh/id_rsa':
State    Recv-Q   Send-Q     Local Address:Port     Peer Address:Port  Process
LISTEN   0        4096       127.0.0.53%lo:53            0.0.0.0:*
LISTEN   0        128              0.0.0.0:22            0.0.0.0:*
LISTEN   0        511                    *:8080                *:*
LISTEN   0        128                 [::]:22               [::]:*
mike@revo:~/git/mike4e/habitat/ansible/apache$
mike@revo:~/git/mike4e/habitat/ansible/apache$ curl http://ec2-3-8-136-28.eu-west-2.compute.amazonaws.com:8080
<html>
    <head>
        <title>Welcome to ec2-3-8-136-28.eu-west-2.compute.amazonaws.com !</title>
    </head>
    <body>
        <h1>Success! The ec2-3-8-136-28.eu-west-2.compute.amazonaws.com virtual host is working!</h1>
    </body>
</html>
mike@revo:~/git/mike4e/habitat/ansible/apache$

```
### ec2_server2

```
mike@revo:~/git/mike4e/habitat/ansible/apache$ ssh ubuntu@ec2-3-8-136-28.eu-west-2.compute.amazonaws.com "ss -tln"
Enter passphrase for key '/home/mike/.ssh/id_rsa':
State    Recv-Q   Send-Q     Local Address:Port     Peer Address:Port  Process
LISTEN   0        4096       127.0.0.53%lo:53            0.0.0.0:*
LISTEN   0        128              0.0.0.0:22            0.0.0.0:*
LISTEN   0        511                    *:8080                *:*
LISTEN   0        128                 [::]:22               [::]:*
mike@revo:~/git/mike4e/habitat/ansible/apache$
mike@revo:~/git/mike4e/habitat/ansible/apache$ curl http://ec2-52-56-201-248.eu-west-2.compute.amazonaws.com:8080
<html>
    <head>
        <title>Welcome to ec2-52-56-201-248.eu-west-2.compute.amazonaws.com !</title>
    </head>
    <body>
        <h1>Success! The ec2-52-56-201-248.eu-west-2.compute.amazonaws.com virtual host is working!</h1>
    </body>
</html>
mike@revo:~/git/mike4e/habitat/ansible/apache$

```
