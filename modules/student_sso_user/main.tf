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

resource "aws_identitystore_group_membership" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
  group_id          = var.identity_store_group_id
  member_id         = aws_identitystore_user.this.user_id
}

# resource "aws_identitystore_group_membership" "this" {
#   identity_store_id = var.identity_store_id
#   group_id          = var.group_id
#   member_id         = aws_identitystore_user.example.user_id
# }

# resource "aws_iam_policy" "user" {
#   name   = "UserAccessStudent${var.email}"
#   path   = "/"
#   policy = data.aws_iam_policy_document.user.json
# }

# resource "aws_iam_user_policy_attachment" "user" {
#   user       = local.student_name
#   policy_arn = aws_iam_policy.user.arn
# }

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  student_name = "${var.first_name} ${var.last_name}"
}