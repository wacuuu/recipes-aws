resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name                = "${var.instance_id}-cpu-treshlod"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 30
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions             = [var.sns_topic_arn]
  dimensions = {
    InstanceId = var.instance_id
  }
}
