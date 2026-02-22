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

  vpc_security_group_ids = [module.blob_sg.security_group_id]  ##aws_security_group.blob.id

  tags = {
    Name = "HelloWorld"
  }
}

module "blob_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"
  name = "blob"

  vpc_id = data.aws_vpc.default.id

  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
