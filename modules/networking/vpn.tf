module "vpn" {
  count             = var.use_openvpn ? 1 : 0
  source            = "../vpn"
  vpn_vpc_id        = aws_vpc.vpc.id
  number_of_subnets = var.number_of_subnets
}
module "tailscale" {
  count            = var.use_tailscale ? 1 : 0
  source           = "../tailscale"
  tailscale_auth   = var.tailscale_auth
  tailscale_cidr   = var.vpc_cidr
  tailscale_subnet = aws_subnet.subnet[0]
  tailscale_vpc_id = aws_vpc.vpc.id

}
