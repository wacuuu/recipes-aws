# module "notifications" {
#   source     = "../../modules/cloudwatch-slack-notifications"
#   slack_hook = var.slack_hook
# }

# variable "slack_hook" {
#   default = ""
# }
module "notifications" {
  source       = "../../modules/cloudwatch-discord-notifications"
  discord_hook = var.discord_hook
}

variable "discord_hook" {}
