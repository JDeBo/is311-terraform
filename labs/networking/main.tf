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
  # for_each         = module.subnets.network_cidr_blocks
  for_each         = var.students
  vpc_id           = aws_vpc.networking_lab.id
  subnet_cidr      = module.subnets.network_cidr_blocks[each.key]
  vpc_cidr         = aws_vpc.networking_lab.cidr_block
  instance_profile = aws_iam_instance_profile.this.id
  # aws_userid       = "${data.aws_iam_role.sso.unique_id}:${each.value.email}"
  aws_userid       = "AROAU6CWOI5MOPHUSZZGO:${each.value.email}"
  instance_name    = "${each.value.firstname}-${each.value.lastname}-networking-final"
  student_id       = "${each.value.firstname}-${each.value.lastname}"
}

module "auto_stopper" {
  source   = "./../../modules/auto_stopper_lambda"
  ec2_map  = { for k, v in module.students : k => v.instance_id }
  use_case = "NetworkingLab"
}

data "aws_iam_roles" "sso" {
  name_regex  = ".*student.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

# data "aws_iam_role" "sso" {
#   name = tolist(data.aws_iam_roles.sso.names)[0]
# }
