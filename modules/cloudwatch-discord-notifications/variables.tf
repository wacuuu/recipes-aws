variable "name" {
  description = "Base name used for few things, like ecr repo, lambda or SNS"
  default     = "alert-notifier"
}

variable "discord_hook" {
  description = "Discord webhook to push messages to"
  type        = string
  nullable    = false
}
