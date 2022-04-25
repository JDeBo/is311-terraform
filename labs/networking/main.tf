terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-networking-lab"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "students" {
  source = "./student_resources"
  for_each = module.subnets.network_cidr_blocks
  student_id = each.key
  vpc_id = aws_vpc.networking_lab.id
  subnet_cidr = each.value
  vpc_cidr = aws_vpc.networking_lab.cidr_block
  instance_profile = aws_iam_instance_profile.this.id
}

module "auto_stopper" {
  source = "./../../modules/auto_stopper_lambda"
  ec2_map = { for k, v in module.students : k => v.instance_id }
  use_case = "NetworkingLab"
}