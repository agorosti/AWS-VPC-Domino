resource "aws_vpc" "some_custom_vpc" {
  cidr_block           = "10.100.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Some Custom VPC"
  }
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name         = "gorostidi.net"
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
}

resource "aws_subnet" "some_public_subnet" {
  vpc_id                  = aws_vpc.some_custom_vpc.id
  cidr_block              = "10.100.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Some Public Subnet"
  }
}

resource "aws_subnet" "some_private_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.100.2.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Some Private Subnet"
  }
}

resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id

  tags = {
    Name = "Some Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.some_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.some_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.some_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}