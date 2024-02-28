output "vpn_password" {
  description = "Password generated for VPN admin"
  value       = module.networking.vpn_webui
}
output "vpn_webui" {
  description = "Address to VPN panel"
  value       = module.networking.vpn_password
}

output "master" {
  value = module.master.instance_ip
}

output "nodes" {
  value = module.nodes.*.instance_ip
}
