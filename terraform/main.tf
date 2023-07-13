terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">=0.14.9"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
  version = "~>3.0"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = ["10.0.101.0/24"]


  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "rt-tf-sg" {
  name        = "rt-tf-sg"
  description = "rt sg block ingress"
  vpc_id      = module.vpc.vpc_id
  
  ingress {
  description = "SSH"
  from_port   = 22  # SSH client port is not a fixed port
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks      = ["217.65.104.98/32"]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "ec2-tf" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = ["${aws_security_group.rt-tf-sg.id}"]
  key_name = "tf-moon"
  associate_public_ip_address = true
  subnet_id = "${element(module.vpc.public_subnets, 0)}"
  
  tags = {
    Name = "HelloWorld"
  }
}
