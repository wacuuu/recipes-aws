variable "name" {
  description = "Base name used for few things, like ecr repo, lambda or SNS"
  default     = "alert-notifier"
}

variable "slack_hook" {
  description = "Slack webhook to push messages to"
  type        = string
  nullable    = false
}
