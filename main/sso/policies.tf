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
        "&{aws:userid}",
      ]
    }
  }

  statement {
    actions = [
      "ec2:DescribeInstances"
    ]

    resources = ["*"]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "ec2" {
  inline_policy      = data.aws_iam_policy_document.ec2.json
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.students.arn
}
