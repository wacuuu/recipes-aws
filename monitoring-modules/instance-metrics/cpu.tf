resource "aws_cloudwatch_metric_alarm" "cpu" {
  count                     = var.monitor_cpu ? 1 : 0
  alarm_name                = "${var.instance_id}-cpu-treshlod"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 30
  alarm_description         = "CPU usage to high on ${var.instance_id}"
  insufficient_data_actions = []
  alarm_actions             = [var.sns_topic_arn]
  ok_actions                = [var.sns_topic_arn]
  dimensions = {
    InstanceId = var.instance_id
  }
}
