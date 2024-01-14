output "vpn_ip" {
  description = "VPN instance IP"
  value       = aws_instance.vpn_instance.public_ip
}
output "vpn_password" {
  description = "Password generated for VPN admin"
  value       = random_string.vpn_password.result
}
output "vpn_webui" {
  description = "Address to VPN panel"
  value       = "https://${length(var.vpn_url) > 0 ? var.vpn_url : aws_instance.vpn_instance.public_ip}:943"
}
output "vpc_id" {
  description = "ID of created VPC"
  value       = aws_vpc.vpc.id
}
output "private_subnets" {
  description = "List of private subnets ids"
  value       = slice(aws_subnet.subnet, 0, var.number_of_subnets - var.number_of_public_subnets - 1).*.id
}
output "public_subnets" {
  description = "Public subnet ID"
  value       = slice(aws_subnet.subnet, var.number_of_subnets - var.number_of_public_subnets - 1, var.number_of_subnets - 1).*.id
}
output "vpc_cidr" {
  description = "CIDR of created VPC"
  value       = aws_vpc.vpc.cidr_block
}
