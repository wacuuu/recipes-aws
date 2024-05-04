output "tailscale_hostname" {
  value = "aws-router-${random_string.tailscale_suffix.result}"
}
