resource "tls_private_key" "devbox" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "devbox" {
  key_name   = "devbox"
  public_key = tls_private_key.devbox.public_key_openssh
}

resource "local_file" "devbox" {
  content         = tls_private_key.devbox.private_key_pem
  filename        = "devbox.pem"
  file_permission = "0600"
}

# Some desc
resource "aws_security_group" "devbox" {
  name   = "devbox"
  vpc_id = aws_vpc.vpc.id
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

data "aws_ami" "devbox" {
  owners = ["099720109477"]
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

resource "aws_instance" "devbox" {
  count = var.create_devbox ? 1 : 0
  lifecycle {
    ignore_changes = [
      ami # avoid rebuilding devbox by accident if they release new AMI
    ]
  }
  instance_type               = var.devbox_type
  ami                         = data.aws_ami.devbox.image_id
  subnet_id                   = aws_subnet.subnet[0].id
  vpc_security_group_ids      = [aws_security_group.devbox.id]
  key_name                    = aws_key_pair.devbox.key_name
  associate_public_ip_address = false
  root_block_device {
    volume_size = 32
  }
  tags = {
    Component = "devbox"
  }
}

# data "template_file" "devbox_hosts" {
#   template = file("${path.module}/hosts.tpl")
#   vars = {
#     instance_ips = aws_instance.devbox.*.private_ip
#     key_path     = "${path.cwd}/${local_file.devbox.filename}"
#   }
# }

resource "local_file" "devbox_hosts" {
  content = templatefile("${path.module}/hosts.tpl", {
    instance_ips = aws_instance.devbox.*.private_ip
    key_path     = "${path.cwd}/${local_file.devbox.filename}"
  })
  filename = "./ansible/devbox"
}
