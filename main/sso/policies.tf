data "aws_iam_policy_document" "ec2" {
  statement {

    actions = [
      "ec2:*",
      "ec2-instance-connect:SendSSHPublicKey",
    ]

    resources = [
      "arn:aws:ec2:${var.region}:${var.target_account_id}:instance/*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/Name"
      values = [
        "Group*",
        "*&{aws:userid}*",
      ]
    }
  }

  statement {
    actions = [
      "ec2:DescribeInstances",
      "cloudshell:*",
    ]
    resources = ["*"]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "ec2" {
  inline_policy      = data.aws_iam_policy_document.ec2.json
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.students.arn
}

resource "aws_iam_policy" "students" {
  name        = "StudentMainPolicy"
  path        = "/"
  description = "Main policy for student users"
  policy = data.aws_iam_policy_document.ec2.json
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "students" {
  instance_arn       = aws_ssoadmin_permission_set.students.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.students.arn
  customer_managed_policy_reference {
    name = aws_iam_policy.students.name
    path = "/"
  }
}