resource "aws_identitystore_user" "this" {
  identity_store_id = var.identity_store_id

  display_name = "${var.first_name} ${var.last_name}"
  user_name    = var.email

  name {
    given_name  = var.first_name
    family_name = var.last_name
  }

  emails {
    value = var.email
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  student_name = "${var.first_name} ${var.last_name}"
}