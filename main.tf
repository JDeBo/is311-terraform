terraform {
  backend "s3" {
    bucket = "terraform-remote-state-932196253170"
    key    = "is-311"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "student_iam" {
  source = "./modules/student_user"

  for_each            = var.students
  student_name        = each.value.name
  student_resource_id = each.key
  keybase_id          = each.value.keybase_id
}

module "teacher_iam" {
  source = "./modules/teacher_user"

  for_each            = var.teachers
  teacher_name        = each.value.name
  teacher_resource_id = each.key
  keybase_id          = each.value.keybase_id
  class_id            = var.class_id
}