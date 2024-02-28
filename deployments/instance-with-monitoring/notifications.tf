module "notifications" {
  source     = "../../modules/cloudwatch-slack-notifications"
  slack_hook = var.slack_hook
}

variable "slack_hook" {
  default = ""
}
