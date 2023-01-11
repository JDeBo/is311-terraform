data "aws_iam_policy_document" "s3" {

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*${var.student_resource_id}*",
    ]
  }
  statement {
    sid = "globalList"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:GetAccountPublicAccessBlock",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketAcl",
      "s3:ListAccessPoints",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "s3" {
  name   = "S3AccessStudent${var.student_resource_id}"
  path   = "/"
  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_user_policy_attachment" "s3" {
  user       = aws_iam_user.student.name
  policy_arn = aws_iam_policy.s3.arn
}