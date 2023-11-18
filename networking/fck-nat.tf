resource "aws_security_group" "fck_nat" {
  name   = "fck-nat"
  vpc_id = aws_vpc.vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [cidrsubnet(aws_vpc.vpc.cidr_block, 0, 0)]
  }
}

resource "aws_network_interface" "fck_nat" {
  subnet_id         = aws_subnet.subnet[var.number_of_subnets - 1].id
  source_dest_check = false
  security_groups   = [aws_security_group.fck_nat.id]
}

resource "tls_private_key" "fck_nat_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "fck_nat_key" {
  key_name   = "fck-nat"
  public_key = tls_private_key.fck_nat_key.public_key_openssh
}

resource "local_file" "fck_nat_key" {
  content         = tls_private_key.fck_nat_key.private_key_pem
  filename        = "fck-nat.pem"
  file_permission = "0600"
}

data "aws_ami" "fck_nat" {
  owners = ["568608671756"]
  filter {
    name   = "name"
    values = ["fck-nat-amzn2-*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  most_recent = true
}

resource "aws_instance" "fck_nat" {
  lifecycle {
    ignore_changes = [
      ami
    ]
  }
  ami           = data.aws_ami.fck_nat.image_id
  instance_type = "t4g.nano"
  key_name      = aws_key_pair.fck_nat_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.fck_nat.id
    device_index         = 0
  }
  root_block_device {
    volume_size = 5
  }
}

resource "aws_route_table" "fck_nat" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.fck_nat.id
  }
}

resource "aws_route_table_association" "fck_nat" {
  count          = var.number_of_subnets - 1
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.fck_nat.id
}
