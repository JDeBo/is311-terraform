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

module "student_iam" {
  source = "../modules/student_user"

  for_each            = var.students
  student_name        = each.value.name
  student_resource_id = each.key
  keybase_id          = each.value.keybase_id
}

resource "aws_iam_group_membership" "student" {
  name = "student_group_membership"

  users = [keys(var.students)]

  group = aws_iam_group.students.name
}



module "teacher_iam" {
  source = "../modules/teacher_user"

  for_each            = var.teachers
  teacher_name        = each.value.name
  teacher_resource_id = each.key
  keybase_id          = each.value.keybase_id
  class_id            = var.class_id
}
