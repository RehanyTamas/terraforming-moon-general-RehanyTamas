# Terraforming Moon

## Story

After SpaceX, the Artemis project of NASA was also successful, so now there are multiple colonies living on the Moon. Because they are not experts of Computer Science, they cannot build application infrastructure, but they need a fast and easily manageable website for their new Moonet™. You are the DevOps engineer that got asked to carry out this noble task. If you accept the offer, your mission is to create an EC2 which can be set up with a push of a button.

## What are you going to learn?

- How to create a basic Terraform project
- How to modify the resources with Terraform

## Tasks

1. Create a Terraform project for AWS EC2 and set security group
    - Terraform is installed on your computer, and the ```terraform version``` command does not return with an error
    - Create EC2 instance with Terraform
    - Create Security Group with Terraform and attach to created EC2 and block all ingress

2. Right now can't reach your EC2 via SSH so now make some changes
    - Enable the SSH port for your machine with Terraform
    - Log in the EC2 via SSH

3. Right now you can reach your EC2 via SSH so now add more IP to the SG
    - Add more IPs to the SG to connect other machines via SSH
    - Ask your friend to log in the EC2 via SSH

## General requirements

None

## Hints

- You can use manged modules for create EC2.
- You can list the IPs in the SG resource.
- If you use Terraform modules, the IDEA can use autofill after ```terraform init```.

## Background materials

- <i class="far fa-book-open"></i> [Terraform Documentation](https://www.terraform.io/docs/index.html)
- <i class="far fa-book-open"></i> [Terraform EC2 module docs](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
- <i class="far fa-book-open"></i> [Terraform SG docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- <i class="far fa-exclamation"></i> [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
