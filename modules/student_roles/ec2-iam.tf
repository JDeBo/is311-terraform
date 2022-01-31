data "aws_iam_policy_document" "ec2" {
  statement {

    actions = [
      "ec2:*",
    ]

    resources = [
      "arn:aws:ec2:::*",
    ]

    condition {
      test = "StringEquals"
      variable = "aws:ResourceTag/Owner"
      values = var.student_name
    }
  }

  statement {

    actions = [
      "ec2:*",
    ]

    resources = [
      "arn:aws:ec2:::*",
    ]

    condition {
      test = "StringEquals"
      variable = "aws:ResourceTag/Owner"

      values = "Group*"
    }
  }

}

resource "aws_iam_policy" "ec2" {
  name   = "EC2AccessStudent"
  path   = "/"
  policy = data.aws_iam_policy_document.ec2.json
}

resource "aws_iam_user_policy_attachment" "ec2" {
  user       = aws_iam_user.student.name
  policy_arn = aws_iam_policy.ec2.arn
}