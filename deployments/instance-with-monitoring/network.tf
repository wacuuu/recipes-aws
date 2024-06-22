module "networking" {
  source         = "../../modules/networking"
  use_tailscale  = true
  tailscale_auth = var.tailscale_auth
}


variable "tailscale_auth" {}
