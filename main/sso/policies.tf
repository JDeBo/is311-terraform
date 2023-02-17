data "aws_iam_policy_document" "sso" {
  statement {
    sid = "studentResources"
    actions = [
      "ec2:*",
      "ec2-instance-connect:SendSSHPublicKey",
      "s3:*"
    ]

    resources = [
      "arn:aws:ec2:${var.region}:${var.target_account_id}:instance/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:subnet/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:route-table/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:security-group*/*",
      "arn:aws:s3:*",

    ]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/Owner"
      values = [
        "Group*",
        "*&{aws:userid}*",
      ]
    }
  }

  statement {
    sid = "globalList"
    actions = [
      "ec2:DescribeInstances",
      "cloudshell:*",
      "access-analyzer:List*",
      "access-analyzer:Get*",
      "access-analyzer:ValidatePolicy",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:GetAccountPublicAccessBlock",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketAcl",
      "s3:ListAccessPoints",
      "workspaces:*",
      "ds:*",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "workspaceDenyCreate"
    effect = "Deny"
    actions = [
      "workspaces:Create*",
      "ds:Create*",
    ]
    resources = ["*"]
  }

}

resource "aws_ssoadmin_permission_set_inline_policy" "sso" {
  inline_policy      = data.aws_iam_policy_document.sso.json
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.students.arn
}
# Probably don't need this
resource "aws_iam_policy" "students" {
  name        = "StudentMainPolicy"
  path        = "/"
  description = "Main policy for student users"
  policy      = data.aws_iam_policy_document.sso.json
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "students" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.students.arn
  customer_managed_policy_reference {
    name = aws_iam_policy.students.name
    path = "/"
  }
}
