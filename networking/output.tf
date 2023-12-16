output "vpn_ip" {
  description = "VPN instance IP"
  value       = aws_instance.vpn_instance.public_ip
}
output "vpn_password" {
  description = "Password generated for VPN admin"
  value       = random_string.vpn_password.result
}
output "vpn_webui" {
  description = "Address to VPN admin panel"
  value       = "https://${length(var.vpn_url) > 0 ? var.vpn_url : aws_instance.vpn_instance.public_ip}:943/admin"
}
output "fck_pem_path" {
  description = "Path to fck nat instance key"
  value       = "${path.cwd}/${local_file.fck_nat_key.filename}"
}
output "vpn_instance_pem_path" {
  description = "Path to fck nat instance key"
  value       = "${path.cwd}/${local_file.vpn_instance.filename}"
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "private_subnets" {
  value = slice(aws_subnet.subnet, 0, var.number_of_subnets - 2).*.id
}
output "public_subnets" {
  value = aws_subnet.subnet[var.number_of_subnets - 1].id
}
output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}
output "instances_to_monitor_id" {
  value = concat(aws_instance.instance.*.id, [aws_instance.vpn_instance.id, aws_instance.fck_nat.id])
}
