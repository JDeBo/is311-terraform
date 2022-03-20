resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "AssumeRoleForLambda"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "ec2_lambda" {
  statement {
    sid       = "LambdaStopInstances"
    effect    = "Allow"
    actions   = ["ec2:StopInstance"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_lambda" {
  path        = "/"
  description = "LambdaStopEC2"
  policy      = data.aws_iam_policy_document.ec2_lambda.json
}
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.ec2_lambda.arn
}

resource "aws_lambda_function" "auto_stopper" {
  filename         = "lambda_function_payload.zip"
  function_name    = "lambda_function_name"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "main.lambda_handler"
  source_code_hash = filebase64sha256("auto_stopper.zip")

  runtime = "python3.8"

  environment {
    variables = {
      EC2_INSTANCES = aws_instance.lab.id
    }
  }
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/auto_stopper/main.py"
  output_path = "${path.module}/auto_stopper.zip"
}