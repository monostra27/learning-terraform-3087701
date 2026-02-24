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

module "blob_alb" {
  source = "terraform-aws-modules/vpc/aws"

  name = "blob_alb"
  vpc_id = module.blob_vpc.vpc_id
  subnets = module.blob_vpc.public_subnets[0]
  
  security_groups = {module.blob_sg.security_group_id}

  listeners = {
    blob-http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_arn = aws_lb_target_group.blob.arn
      }
    }
  
  tags = {
    Environment = "Development"
    }
}

resource "aws_lb_target_group" "blob {
  name     = "blob"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.blob_vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "blob" {
  target_group_arn = aws_lb_target_group.blob.arn
  target_id        = aws_instance.blob.id
  port             = 80
}

