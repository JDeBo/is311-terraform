resource "aws_iam_user" "student" {
  name          = var.student_resource_id
  force_destroy = true
}

resource "aws_iam_access_key" "student" {
  user = aws_iam_user.student.name
  # pgp_key = "keybase:${var.keybase_id}"
}

resource "aws_iam_user_login_profile" "student" {
  user = aws_iam_user.student.name
  # pgp_key = "keybase:${var.keybase_id}"
  password_length         = 8
  password_reset_required = true
  lifecycle {
    ignore_changes = [
      password_length,
    ]
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