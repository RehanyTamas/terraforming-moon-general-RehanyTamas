# Terraforming Moon

## Description
This is a terraforming project with the aim of creating a functioning ec2 instance (and the necessary resources to support it) with the usage of AWS.

## Created resources
- VPC
- Several private and public subnets
- Internet gateway
- Route table (and associations)
- Security group
- AWS instance (ubuntu based)

## Used Technologies

- Terraform
- AWS

## Installation

This project requires that your machine has terraform installed and that zou have a working AWS account.

1. Download this repository to your machine
2. Navigate to the project directory
3. Init the backend for terraform
  ```sh
  terraform init
  ```
4. Take a look at AWS resourcces zou are about to create
  ```sh
  terraform plan
  ```
5. Create the resources
  ```sh
  terraform apply -auto-approve
  ```
Once this is done the ec2 instance has been created and zou can log into it with the key found in this repository.
