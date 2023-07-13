terraform {
  required_version = "~> 0.12.31"

  required_providers {
    aws  = "~> 3.74.1"
  }
}

provider "aws" {
  region = "us-west-2"
}



resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 tags = {
   Name = "Project VPC"
 }
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }

}

variable "azs" {

 type        = list(string)

 description = "Availability Zones"

 default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

}

resource "aws_subnet" "public_subnets" {

 count             = length(var.public_subnet_cidrs)

 vpc_id            = aws_vpc.main.id

 cidr_block        = element(var.public_subnet_cidrs, count.index)

 availability_zone = element(var.azs, count.index)

 

 tags = {

   Name = "Public Subnet ${count.index + 1}"

 }

}

 

resource "aws_subnet" "private_subnets" {

 count             = length(var.private_subnet_cidrs)

 vpc_id            = aws_vpc.main.id

 cidr_block        = element(var.private_subnet_cidrs, count.index)

 availability_zone = element(var.azs, count.index)

 

 tags = {

   Name = "Private Subnet ${count.index + 1}"

 }

}

resource "aws_internet_gateway" "gw" {

 vpc_id = aws_vpc.main.id

 

 tags = {

   Name = "Project VPC IG"

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

resource "aws_route_table" "second_rt" {

 vpc_id = aws_vpc.main.id

 

 route {

   cidr_block = "0.0.0.0/0"

   gateway_id = aws_internet_gateway.gw.id

 }

 

 tags = {

   Name = "2nd Route Table"

 }

}

resource "aws_route_table_association" "public_subnet_asso" {

 count = length(var.public_subnet_cidrs)

 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)

 route_table_id = aws_route_table.second_rt.id

}

resource "aws_security_group" "rt-tf-sg" {
  name        = "rt-tf-sg"
  description = "rt sg block ingress"
  vpc_id      = aws_vpc.main.vpc_id
  
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
