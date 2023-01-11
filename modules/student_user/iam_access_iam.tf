data "aws_iam_policy_document" "iam_access_analyzer" {

  statement {
    actions = [
      "access-analyzer:List*",
      "access-analyzer:Get*",
      "access-analyzer:ValidatePolicy",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "iam_access_analyzer" {
  name   = "IAMAccessAnalyzerStudent${var.email}"
  path   = "/"
  policy = data.aws_iam_policy_document.iam_access_analyzer.json
}

resource "aws_iam_user_policy_attachment" "iam_access_analyzer" {
  user       = aws_iam_user.student.name
  policy_arn = aws_iam_policy.iam_access_analyzer.arn
}