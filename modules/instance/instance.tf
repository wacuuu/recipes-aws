
resource "aws_security_group" "instance" {
  count  = var.use_external_sg ? 0 : 1
  name   = var.instance_name
  vpc_id = var.vpc_id
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
  count  = length(var.ami_id) > 0 ? 0 : 1
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
  lifecycle {
    ignore_changes = [
      ami # avoid rebuilding instance by accident if they release new AMI
    ]
  }
  instance_type               = var.instance_type
  ami                         = length(var.ami_id) > 0 ? var.ami_id : data.aws_ami.instance[0].image_id
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.use_external_sg ? var.security_group_id : aws_security_group.instance[0].id]
  key_name                    = var.key_name
  associate_public_ip_address = var.public_ip
  root_block_device {
    volume_size = var.root_size
    volume_type = var.volume_type
  }
  tags = var.tags
}
