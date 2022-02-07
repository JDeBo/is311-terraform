data "aws_iam_policy_document" "s3" {

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*${var.student_resource_id}*",
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