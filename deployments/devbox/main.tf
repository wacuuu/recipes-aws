module "networking" {
  source                   = "../../modules/networking"
  number_of_public_subnets = 1
  use_tailscale            = true
  tailscale_auth           = var.tailscale_auth
}

module "keypair" {
  source = "../../modules/instance_keypair"
  name   = "devbox"
}

module "devbox" {
  source        = "../../modules/instance"
  vpc_id        = module.networking.vpc_id
  instance_name = "devbox"
  key_name      = module.keypair.key_name
  subnet_id     = module.networking.private_subnets[0]
}

resource "local_file" "devbox_hosts" {
  file_permission = 0664
  content = templatefile("../../ansible/hosts.tpl", {
    instance_ips = [module.devbox.instance_ip]
    key_path     = module.keypair.key_path
    username     = "ubuntu"
  })
  filename = "../../ansible/devbox-hosts.yaml"
}
