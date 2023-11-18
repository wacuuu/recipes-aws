
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

data "aws_region" "region" {
  provider = aws
}
data "aws_availability_zones" "zones" {
  filter {
    name   = "region-name"
    values = [data.aws_region.region.name]
  }
}

resource "aws_subnet" "subnet" {
  count             = var.number_of_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.number_of_subnets, count.index)
  availability_zone = var.force_one_zone ? data.aws_availability_zones.zones.names[0] : null
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "default_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_network" {
  subnet_id      = aws_subnet.subnet[var.number_of_subnets - 1].id
  route_table_id = aws_route_table.default_public.id
}
