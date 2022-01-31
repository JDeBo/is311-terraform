provider "aws" {
    version = ">= 3.4"
}

resource "aws_iam_user" "student" {
  name = var.student_resource_name
  force_destroy = true
  tags = var.tags
}