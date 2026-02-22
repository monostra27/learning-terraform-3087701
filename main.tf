data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "blob" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type   ##t 2.micro  ##"t3.nano" t3.micro"

  vpc_security_group_ids = [module.blob.sg.security_group_id]  ##aws_security_group.blob.id

  tags = {
    Name = "HelloWorld"
  }
}

module "blob_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"
  name = "blob_new"

  vpc_id = data.aws_vpc.default.id

  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group" "blob" {
  name = "blob"
  description = "Allow http and https in. Allow everthing out"

  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "blob_http_in" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blob.id
}

resource "aws_security_group_rule" "blob_https_in" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blob.id
}

resource "aws_security_group_rule" "blob_everything_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blob.id
}
