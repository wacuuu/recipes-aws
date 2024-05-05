output "vpn_ip" {
  description = "VPN instance IP"
  value       = var.use_openvpn ? module.vpn.vpn_webui : null
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
