locals {
  cert-tester-name    = "${var.environment}-${var.project}-lambda-cert-tester"
  cert-tester-zipfile = "${path.module}/lambda-cert-tester.zip"
}

data "archive_file" "cert-tester" {
  type             = "zip"
  source_dir       = "${path.module}/lambda-cert-tester"
  output_path      = local.cert-tester-zipfile
  output_file_mode = "0666"
}

resource "aws_cloudwatch_log_group" "cert-tester-lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.cert-tester.function_name}"
  retention_in_days = var.log_retention
}

resource "aws_lambda_function" "cert-tester" {
  function_name    = local.cert-tester-name
  description      = "Checks SSL certificate expiration date"
  role             = aws_iam_role.cert-tester.arn
  filename         = local.cert-tester-zipfile
  handler          = "cert-tester.lambda_handler"
  runtime          = "python3.13"
  timeout          = 6
  source_code_hash = data.archive_file.cert-tester.output_base64sha256

  depends_on = [
    aws_iam_role.cert-tester,
  ]

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
      HOST          = var.domain
    }
  }
}

resource "aws_iam_role" "cert-tester" {
  name               = "${local.cert-tester-name}-role"
  description        = "Role used for lambda function ${local.cert-tester-name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_cert-tester_configuration.json
}

resource "aws_iam_role_policy" "cert-tester" {
  name   = "${local.cert-tester-name}-policy"
  policy = data.aws_iam_policy_document.role_cert-tester.json
  role   = aws_iam_role.cert-tester.id
}

data "aws_iam_policy_document" "assume_role_cert-tester_configuration" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "role_cert-tester" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cert-tester-lambda_logs.arn}*"
    ]
  }

  statement {
    actions = [
      "sns:Publish"
    ]

    resources = [
      var.sns_topic_arn
    ]
  }
}


resource "aws_lambda_permission" "default" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cert-tester.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.default.arn
}

resource "aws_cloudwatch_event_rule" "default" {
  name                = local.cert-tester-name
  description         = local.cert-tester-name
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "default" {
  target_id = local.cert-tester-name
  rule      = aws_cloudwatch_event_rule.default.name
  arn       = aws_lambda_function.cert-tester.arn
}