module "vpn_key" {
  source = "../instance_keypair"
  name   = "vpn-key"
}

locals {
  sg_ports = [22, 443, 943, 945, 1194, 80]
}

resource "aws_security_group" "vpn" {
  name   = "openvpn_instance"
  vpc_id = aws_vpc.vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  dynamic "ingress" {
    for_each = local.sg_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

data "aws_ami" "vpn" {
  owners = ["679593333241"]
  filter {
    name   = "name"
    values = ["OpenVPN Access Server QA Image*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  most_recent = true
}

resource "random_string" "vpn_password" {
  length  = 8
  special = false
}


resource "aws_instance" "vpn_instance" {
  lifecycle {
    ignore_changes = [
      ami # avoid rebuilding instance by accident if they release new AMI
    ]
  }
  instance_type               = "t3.micro"
  ami                         = data.aws_ami.vpn.image_id
  subnet_id                   = aws_subnet.subnet[var.number_of_subnets - 1].id
  vpc_security_group_ids      = [aws_security_group.vpn.id]
  key_name                    = module.vpn_key.key_name
  associate_public_ip_address = true
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }
  user_data = <<EOF
${length(var.vpn_url) > 0 ? "public_hostname= ${var.vpn_url}" : ""}
admin_user=admin
admin_pw=${random_string.vpn_password.result}
EOF
}


