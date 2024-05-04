module "networking" {
  source                   = "../../modules/networking"
  number_of_public_subnets = 1
  use_tailscale            = true
  tailscale_auth           = var.tailscale_auth
  tailscale_router_suffix  = "default"
}
