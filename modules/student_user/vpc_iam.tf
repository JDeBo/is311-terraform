data "aws_iam_policy_document" "vpc" {
  statement {

    actions = [
      "ec2:*",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:subnet/*",
      "arn:aws:ec2:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:route-table/*",
      "arn:aws:ec2:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:security-group*/*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/Name"
      values = [
        "*${var.email}",
      ]
    }
  }
}

resource "aws_iam_policy" "vpc" {
  name   = "vpcAccessStudent${var.email}"
  path   = "/"
  policy = data.aws_iam_policy_document.vpc.json
}

resource "aws_iam_user_policy_attachment" "vpc" {
  user       = local.student_name
  policy_arn = aws_iam_policy.vpc.arn
}
