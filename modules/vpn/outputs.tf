output "vpn_webui" {
  description = "Address to VPN panel"
  value       = "https://${length(var.vpn_url) > 0 ? var.vpn_url : aws_instance.vpn_instance.public_ip}:943"
}
output "vpn_password" {
  description = "Password generated for VPN admin"
  value       = random_string.vpn_password.result
}
