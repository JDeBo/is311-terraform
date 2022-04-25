data "aws_iam_policy_document" "vpc" {
  statement {

    actions = [
      "ec2:*Subnet*",
      "ec2:*RouteTable*",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:subnet/*",
      "arn:aws:ec2:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:route-table/*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/Name"
      values = [
        "*${var.student_resource_id}",
      ]
    }
  }
}

resource "aws_iam_policy" "vpc" {
  name   = "vpcAccessStudent${var.student_resource_id}"
  path   = "/"
  policy = data.aws_iam_policy_document.vpc.json
}

resource "aws_iam_user_policy_attachment" "vpc" {
  user       = aws_iam_user.student.name
  policy_arn = aws_iam_policy.vpc.arn
}
