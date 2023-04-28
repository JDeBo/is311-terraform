terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-network-sim"
    }
  }
}

provider "aws" {
  region = local.region
}

locals {
  vpc_cidr  = "10.0.0.0/16"
  db_ip     = "10.0.1.10"
  region    = "us-east-2"
  name      = "network-sim"
  tags      = {}
  user_data = <<-EOT
  #!/bin/bash
  echo "Hello Terraform!"
  EOT
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.vpc_cidr

  azs            = ["${local.region}a"]
  public_subnets = cidrsubnets(local.vpc_cidr, 4, 4, 4, 4)

  enable_nat_gateway = false

  tags = local.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.name
  description = "Security group for local IP ssh"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  tags = local.tags
}

# module "db" {
#   count   = 0
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   ami        = data.aws_ami.latest.id
#   subnet_id  = module.vpc.public_subnets[0]
#   private_ip = local.db_ip
# }

module "class_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  for_each = toset(["1"])
  name     = "${local.name}-${each.key}"

  ami                         = data.aws_ami.netsim.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main.key_name
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  disable_api_stop            = false
  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true
  tags                        = local.tags
}

resource "aws_key_pair" "main" {
  key_name   = local.name
  public_key = tls_private_key.ed25519.public_key_openssh
}

# ED25519 key
resource "tls_private_key" "ed25519" {
  algorithm = "ED25519"
}

output "tls_private_key" {
  value = trimspace(tls_private_key.ed25519.private_key_pem)
  sensitive = true
}

