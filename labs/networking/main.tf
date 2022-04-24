terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-networking-lab"
    }
  }
}

module "individual_ec2s" {
  source = "./../../modules/ec2_instance"
  for_each = aws_subnet.student_subnets
  name = "is311-networking-${each.value.tags_all.Name}"
  subnet_id = each.value.id
}

module "auto_stopper" {
  source = "./../../modules/auto_stopper_lambda"
  ec2_map = { for k, v in individual_ec2s : k => v.instance_id }
  use_case = "NetworkingLab"
}