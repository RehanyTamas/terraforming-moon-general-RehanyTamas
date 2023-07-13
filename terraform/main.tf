
terraform {
  required_version = "~> 0.12.31"

  required_providers {
    aws  = "~> 3.74.1"
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
    Name = "HelloWorld"
  }
}
