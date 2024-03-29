resource "aws_iam_role" "iam_for_lambda" {
  name = "StopEC2LambdaRole"

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
    actions   = ["ec2:StopInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_lambda" {
  path        = "/"
  description = "LambdaStopEC2"
  policy      = data.aws_iam_policy_document.ec2_lambda.json
}

resource "aws_iam_role_policy_attachment" "ec2_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.ec2_lambda.arn
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "auto_stopper" {
  filename         = "auto_stopper.zip"
  function_name    = "auto_stop_ec2s"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.auto_stopper.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      EC2_INSTANCES = jsonencode({ for k, v in module.instances : k => v.instance_id })
    }
  }
  depends_on = [
    data.archive_file.auto_stopper
  ]
}

data "archive_file" "auto_stopper" {
  type        = "zip"
  source_file = "${path.module}/auto_stopper/main.py"
  output_path = "${path.module}/auto_stopper.zip"
}