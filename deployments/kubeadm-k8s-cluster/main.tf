module "networking" {
  source                   = "../../modules/networking"
  number_of_public_subnets = 1
}

module "keypair" {
  source = "../../modules/instance_keypair"
  name   = "kubeadm"
}

module "master" {
  source        = "../../modules/instance"
  vpc_id        = module.networking.vpc_id
  instance_name = "master"
  key_name      = module.keypair.key_name
  subnet_id     = module.networking.private_subnets[0]
}

module "nodes" {
  count         = 3
  source        = "../../modules/instance"
  vpc_id        = module.networking.vpc_id
  instance_name = "node-${count.index}"
  key_name      = module.keypair.key_name
  subnet_id     = module.networking.private_subnets[0]
}

resource "local_file" "master" {
  file_permission = 0664
  content = templatefile("../../ansible/hosts.tpl", {
    instance_ips = [module.master.instance_ip]
    key_path     = module.keypair.key_path
    username     = "ubuntu"
  })
  filename = "../../ansible/master-hosts.yaml"
}

resource "local_file" "nodes" {
  file_permission = 0664
  content = templatefile("../../ansible/hosts.tpl", {
    instance_ips = module.nodes.*.instance_ip
    key_path     = module.keypair.key_path
    username     = "ubuntu"
  })
  filename = "../../ansible/nodes-hosts.yaml"
}
