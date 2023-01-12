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

module "student_iam" {
  source = "../../modules/student_sso_user"

  for_each          = var.students
  first_name        = each.value.first_name
  last_name         = each.value.last_name
  email             = each.value.email
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

resource "aws_identitystore_group" "students" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = "IS311-Students"
  description       = "Student Group for IS311"
}
