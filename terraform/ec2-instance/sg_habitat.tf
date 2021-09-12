resource "aws_security_group" "sg_habitat" {
  name        = "sg_habitat"
  description = "controls access to the EC2 instance"
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.sg_habitat.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

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

resource "aws_security_group_rule" "icmp" {
  security_group_id = aws_security_group.sg_habitat.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["${var.revo_ip}/32"]
}
