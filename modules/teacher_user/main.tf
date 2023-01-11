resource "aws_iam_user" "teacher" {
  name          = var.teacher_resource_id
  force_destroy = true
}

resource "aws_iam_access_key" "teacher" {
  user    = aws_iam_user.teacher.name
  pgp_key = "keybase:${var.keybase_id}"
}

resource "aws_iam_user_login_profile" "teacher" {
  user                    = aws_iam_user.teacher.name
  pgp_key                 = "keybase:${var.keybase_id}"
  password_length         = 8
  password_reset_required = true
  lifecycle {
    ignore_changes = [
      password_length,
    ]
  }
}

data "aws_iam_policy_document" "main" {

  statement {

    actions = [
      "iam:ChangePassword",
      "iam:GetAccountPasswordPolicy",
    ]

    resources = [
      "arn:aws:iam::932196253170:user/${var.teacher_resource_id}",
    ]
  }
  statement {

    actions = [
      "ec2:*",
    ]

    resources = [
      "arn:aws:ec2:::*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Class"
      values = [
        var.class_id,
      ]
    }
  }

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*${var.class_id}*",
    ]
  }


}

resource "aws_iam_policy" "main" {
  name   = "UserAccessTeacher${var.teacher_resource_id}"
  path   = "/"
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_user_policy_attachment" "main" {
  user       = aws_iam_user.teacher.name
  policy_arn = aws_iam_policy.main.arn
}