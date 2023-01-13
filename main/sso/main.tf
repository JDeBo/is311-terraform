terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-sso"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_ssoadmin_instances" "this" {}

locals {
  sso_instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

# In order for students to be able to set that password on login, set OTP on signin
# in the identity center console https://docs.aws.amazon.com/singlesignon/latest/userguide/userswithoutpwd.html
module "student_iam" {
  source = "../../modules/student_sso_user"

  for_each          = var.students
  first_name        = each.value.first_name
  last_name         = each.value.last_name
  email             = each.value.email
  identity_store_id = local.sso_instance_arn
}

resource "aws_identitystore_group" "students" {
  identity_store_id = local.sso_instance_arn
  display_name      = "IS311-Students"
  description       = "Student Group for IS311"
}

resource "aws_ssoadmin_account_assignment" "students" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.students.arn

  principal_id   = data.aws_identitystore_group.students.group_id
  principal_type = "GROUP"

  target_id   = var.target_account_id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_permission_set" "students" {
  name             = "IS311 Students"
  description      = "Permission set for students"
  instance_arn     = local.sso_instance_arn
  relay_state      = "https://us-east-2.console.aws.amazon.com/console/home?region=us-east-2"
  session_duration = "PT3H"
}
