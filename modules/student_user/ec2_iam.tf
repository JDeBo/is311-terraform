data "aws_iam_policy_document" "ec2" {
  statement {

    actions = [
      "ec2:*",
      "ec2-instance-connect:SendSSHPublicKey",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:instance/*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/Name"
      values = [
        "Group*",
        "*${var.email}",
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

resource "aws_iam_policy" "ec2" {
  name   = "EC2AccessStudent${var.email}"
  path   = "/"
  policy = data.aws_iam_policy_document.ec2.json
}

resource "aws_iam_user_policy_attachment" "ec2" {
  user       = aws_iam_user.student.name
  policy_arn = aws_iam_policy.ec2.arn
}
