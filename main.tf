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

module "vcp_blob" {
  source = "terraform-aws-modules/vcp/aws"

  name = "dev"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "blob" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type   ##t 2.micro  ##"t3.nano" t3.micro"

  vcp_security_group_ids = [module.blob_sg.security_group_id]  ##aws_security_group.blob.id

  subnet_id = module.blob_vcp.public_subnets[0]

  tags = {
    Name = "HelloWorld"
  }
}

module "blob_vcp {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"
  name = "blob"

  vcp_id = module.blob_vcp.vcp.id

  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
