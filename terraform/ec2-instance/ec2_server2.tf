resource "aws_instance" "ec2_server2" {
  ami           = "ami-0194c3e07668a7e36"
  instance_type = "t2.micro"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_habitat.id]

  tags = {
    Name = "ec2_server2"
  }
}
