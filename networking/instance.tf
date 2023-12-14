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
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230919"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
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
}

# data "terraform_remote_state" "monitoring" {
#   backend = "local"
#   config = {
#     path = "${path.module}/../cloudwatch-slack-notifications/terraform.tfstate"
#   }
# }

# module "instance_monitoring" {
#   for_each      = { for instance in aws_instance.instance : instance.id => instance }
#   source        = "../monitoring-modules/instance-metrics"
#   instance_id   = each.key
#   sns_topic_arn = data.terraform_remote_state.monitoring.outputs.sns_topic_arn
# }

