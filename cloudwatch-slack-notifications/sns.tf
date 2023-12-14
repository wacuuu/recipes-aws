resource "aws_sns_topic" "cloudwatch_notifications" {
  name         = "cloudwatch-to-slack"
  display_name = "Cloudwatch to slack notifications"
}

resource "aws_sns_topic_subscription" "lambda_slack" {
  topic_arn = aws_sns_topic.cloudwatch_notifications.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ecr_lambda.arn
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecr_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.cloudwatch_notifications.arn
}
