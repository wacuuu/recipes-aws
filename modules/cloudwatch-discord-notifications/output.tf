output "sns_topic_arn" {
  description = "SNS topic ARN, to be used with cloudwatch definitions"
  value       = aws_sns_topic.cloudwatch_notifications.arn
}
