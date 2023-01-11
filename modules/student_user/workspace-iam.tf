data "aws_iam_policy_document" "workspace" {
  statement {

    actions = [
      "workspaces:*",
      "ds:*",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "denyCreate"
    effect = "Deny"
    actions = [
      "workspaces:Create*",
      "ds:Create*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "workspace" {
  name   = "WorkspaceAccessStudent${var.email}"
  path   = "/"
  policy = data.aws_iam_policy_document.workspace.json
}

resource "aws_iam_user_policy_attachment" "workspace" {
  user       = aws_iam_user.student.name
  policy_arn = aws_iam_policy.workspace.arn
}