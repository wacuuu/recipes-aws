variable "name" {
  default = "alert-notifier"
}

variable "slack_hook" {
  type     = string
  nullable = false
}
