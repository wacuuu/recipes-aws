resource "tls_private_key" "instance" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "instance" {
  key_name   = "instance"
  public_key = tls_private_key.instance.public_key_openssh
}

resource "local_file" "instance" {
  content         = tls_private_key.instance.private_key_pem
  filename        = "instance.pem"
  file_permission = "0600"
}

# Some desc
resource "aws_security_group" "instance" {
  name   = "instance"
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

data "aws_ami" "instance" {
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

resource "aws_instance" "instance" {
  count = var.create_instance
  lifecycle {
    ignore_changes = [
      ami # avoid rebuilding instance by accident if they release new AMI
    ]
  }
  instance_type               = "t3.medium"
  ami                         = data.aws_ami.instance.image_id
  subnet_id                   = aws_subnet.subnet[0].id
  vpc_security_group_ids      = [aws_security_group.instance.id]
  key_name                    = aws_key_pair.instance.key_name
  associate_public_ip_address = false
  root_block_device {
    volume_size = 32
  }
  tags = {
    Component = "instances"
  }
}

# data "template_file" "instance_hosts" {
#   template = file("${path.module}/hosts.tpl")
#   vars = {
#     instance_ips = aws_instance.instance.*.private_ip
#     key_path     = "${path.cwd}/${local_file.instance.filename}"
#   }
# }

resource "local_file" "instance_hosts" {
  content = templatefile("${path.module}/hosts.tpl", {
    instance_ips = aws_instance.instance.*.private_ip
    key_path     = "${path.cwd}/${local_file.instance.filename}"
  })
  filename = "./ansible/instances"
}
