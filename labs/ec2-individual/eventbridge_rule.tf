resource "aws_cloudwatch_event_rule" "stop_instances" {
  name                = "StopInstance"
  description         = "Stop instances nightly"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.stop_instances.name
  target_id = "StopInstance"
  arn       = aws_lambda_function.auto_stopper.arn
}

data "aws_iam_policy_document" "eventbridge_lambda" {
  statement {
    sid     = "EventBridgeInvokeLambda"
    effect  = "Allow"
    actions = ["lambda:InvokeFunction"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_lambda_function.auto_stopper.arn]
  }
}

resource "aws_iam_policy" "eventbridge_lambda" {
  path        = "/"
  description = "EventBridgeInvokeLambda"
  policy      = data.aws_iam_policy_document.eventbridge_lambda.json
}
resource "aws_iam_role_policy_attachment" "eventbridge_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.eventbridge_lambda.arn
}