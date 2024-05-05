module "networking" {
  source                   = "../../modules/networking"
  number_of_public_subnets = 1
  use_tailscale            = true
  tailscale_auth           = var.tailscale_auth
}
module "keypair" {
  source = "../../modules/instance_keypair"
  name   = "kubeadm"
}

resource "aws_security_group" "this" {
  name   = "common groupo"
  vpc_id = module.networking.vpc_id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


module "master" {
  source            = "../../modules/instance"
  vpc_id            = module.networking.vpc_id
  instance_name     = "master"
  key_name          = module.keypair.key_name
  subnet_id         = module.networking.private_subnets[0]
  security_group_id = aws_security_group.this.id
  use_external_sg   = true
  tags = {
    Name = "master-1"
  }
  root_size = 12
}

module "nodes" {
  count             = 3
  use_external_sg   = true
  source            = "../../modules/instance"
  vpc_id            = module.networking.vpc_id
  instance_name     = "node-${count.index}"
  key_name          = module.keypair.key_name
  subnet_id         = module.networking.private_subnets[0]
  security_group_id = aws_security_group.this.id
  tags = {
    Name = "node-${count.index}"
  }
  root_size = 12
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
