data "aws_iam_policy_document" "sso" {
  statement {
    sid = "studentResources"
    actions = [
      "ec2:*",
      "ec2-instance-connect:SendSSHPublicKey",
      "route53:*"
    ]

    resources = [
      "arn:aws:ec2:${var.region}:${var.target_account_id}:instance/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:subnet/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:vpc/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:route-table/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:security-group*/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:image/*",
      "arn:aws:route53:::hostedzone/*",	
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
    sid = "classResources"
    actions = [
      "ec2:List*",
      "ec2:Describe*",
    ]

    resources = [
      "arn:aws:ec2:${var.region}:${var.target_account_id}:instance/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:subnet/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:vpc*/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:route-table/*",
      "arn:aws:ec2:${var.region}:${var.target_account_id}:security-group*/*",
    ]

    # condition {
    #   test     = "StringLike"
    #   variable = "aws:ResourceTag/Owner"
    #   values = [
    #     "*is311*"
    #   ]
    # }
  }

  statement {
    sid = "studentS3"
    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::*&{aws:PrincipalTag/DisplayName}*",
      "arn:aws:s3:::*&{aws:PrincipalTag/DisplayName}*/*",
    ]
  }

  statement {
    sid = "classS3"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:List*"
    ]

    resources = [
      "arn:aws:s3:::*group*",
      "arn:aws:s3:::*group*/*",
    ]
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
      "compute-optimizer:GetEnrollmentStatus",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:Describe*",
      "autoscaling:Describe*",
      "elasticloadbalancing:Describe*",
      "ssm:DescribeInstanceInformation"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "workspaceDenyCreate"
    effect = "Deny"
    actions = [
      "workspaces:Create*",
      "ds:Create*",
      "ec2:TerminateInstances"
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

# resource "aws_ssoadmin_customer_managed_policy_attachment" "students" {
#   instance_arn       = local.sso_instance_arn
#   permission_set_arn = aws_ssoadmin_permission_set.students.arn
#   customer_managed_policy_reference {
#     name = aws_iam_policy.students.name
#     path = "/"
#   }
# }
