output "vpn_password" {
  description = "Password generated for VPN admin"
  value       = module.networking.vpn_webui
}
output "vpn_webui" {
  description = "Address to VPN panel"
  value       = module.networking.vpn_password
}
output "devbox_ip" {
  value = module.devbox.instance_ip
}
