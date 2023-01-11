terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-main"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_ssoadmin_instances" "this" {}

module "student_iam" {
  source = "../modules/student_user"

  for_each          = var.students
  first_name        = each.value.first_name
  last_name         = each.value.last_name
  email             = each.value.email
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# resource "aws_identitystore_group" "students" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
#   display_name      = "IS311-Students"
#   description       = "Student Group for IS311"
# }

# resource "aws_identitystore_group_membership" "example" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
#   group_id          = aws_identitystore_group.example.group_id
#   member_id         = aws_identitystore_user.example.user_id
# }

module "teacher_iam" {
  source = "../modules/teacher_user"

  for_each            = var.teachers
  teacher_name        = each.value.name
  teacher_resource_id = each.key
  keybase_id          = each.value.keybase_id
  class_id            = var.class_id
}
