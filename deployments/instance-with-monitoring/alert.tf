module "instance_alert" {
  source        = "../../modules/instance-metrics"
  instance_id   = module.instance.instance_id
  sns_topic_arn = module.notifications.sns_topic_arn
}
