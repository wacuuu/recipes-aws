data "terraform_remote_state" "monitoring" {
  backend = "local"
  config = {
    path = "${path.module}/../cloudwatch-slack-notifications/terraform.tfstate"
  }
}

data "terraform_remote_state" "networking_instances" {
  backend = "local"
  config = {
    path = "${path.module}/../networking/terraform.tfstate"
  }
}

module "instance_monitoring" {
  for_each      = toset(data.terraform_remote_state.networking_instances.outputs.instances_to_monitor_id)
  source        = "../monitoring-modules/instance-metrics"
  instance_id   = each.key
  sns_topic_arn = data.terraform_remote_state.monitoring.outputs.sns_topic_arn
  monitor_cpu   = true
}

