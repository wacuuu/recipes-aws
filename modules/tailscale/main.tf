module "tailscale_key" {
  source = "../instance_keypair"
  name   = "tailscale-key"
}

data "aws_ami" "ubuntu" {
  # owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  most_recent = true
}

resource "aws_security_group" "tailscale" {
  name   = "tailscale_instance"
  vpc_id = var.tailscale_vpc_id
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

resource "aws_network_interface" "tailscale" {
  subnet_id         = var.tailscale_subnet
  source_dest_check = false
  security_groups   = [aws_instance.tailscale.id]
}

resource "random_string" "tailscale_suffix" {
  length  = 8
  special = false
}

resource "aws_instance" "tailscale" {
  lifecycle {
    ignore_changes = [
      ami # avoid rebuilding instance by accident if they release new AMI
    ]
  }

  instance_type = "t2.micro"
  ami           = data.aws_ami.ubuntu.image_id
  # subnet_id                   = module.test_cloud_network.subnet_ids[2]
  # vpc_security_group_ids      = [aws_security_group.test_cloud.id]
  key_name = aws_key_pair.tailscale_key.key_name
  # associate_public_ip_address = false
  network_interface {
    network_interface_id = aws_network_interface.tailscale
    device_index         = 0
  }
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "tailscale"
  }
  user_data = <<-EOF
#!/bin/bash
set -x
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

apt update && apt-get -y upgrade
apt-get -y install tailscale
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf
tailscale up --auth-key=${var.tailscale_auth} --advertise-routes=${var.tailscale_cidr} --hostname=aws-router-${random_string.tailscale_suffix.result} --advertise-tags=tag:aws-network,tag:exit-node --reset --accept-routes --advertise-exit-node
EOF
}

