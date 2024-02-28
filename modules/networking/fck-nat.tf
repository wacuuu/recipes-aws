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

module "fck_nat_key" {
  source = "../instance_keypair"
  name   = "fck-nat"
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
      ami # avoid rebuilding instance by accident if they release new AMI
    ]
  }
  ami           = data.aws_ami.fck_nat.image_id
  instance_type = "t4g.nano"
  key_name      = module.fck_nat_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.fck_nat.id
    device_index         = 0
  }
  root_block_device {
    volume_size = 5
    volume_type = "gp3"
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
  for_each       = { for i in range(0, var.number_of_subnets - var.number_of_public_subnets) : i => aws_subnet.subnet[i] }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.fck_nat.id
}
