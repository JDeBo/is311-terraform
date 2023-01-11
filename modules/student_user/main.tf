resource "aws_identitystore_user" "student" {
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

data "aws_iam_policy_document" "user" {

  statement {

    actions = [
      "iam:ChangePassword",
      "iam:GetAccountPasswordPolicy",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.student_resource_id}",
    ]
  }

}

resource "aws_iam_policy" "user" {
  name   = "UserAccessStudent${var.student_resource_id}"
  path   = "/"
  policy = data.aws_iam_policy_document.user.json
}

resource "aws_iam_user_policy_attachment" "user" {
  user       = aws_iam_user.student.name
  policy_arn = aws_iam_policy.user.arn
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}