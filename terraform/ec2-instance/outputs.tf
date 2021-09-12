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
