# VPC
resource "aws_vpc" "mern-estate-vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "mern-estate"
  }
}

# Public Subnet
resource "aws_subnet" "mern-estate-public-subnet" {
  count             = 2
  vpc_id            = aws_vpc.mern-estate-vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true 
  tags = {
    Name = "mern-estate-public-subnet[${count.index}]"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private subnet

resource "aws_subnet" "mern-estate-private-subnet" {
  count             = 2
  vpc_id            = aws_vpc.mern-estate-vpc.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "mern-estate-private-subnet[${count.index}]"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Elatic eip
resource "aws_eip" "mern-estate-eip" {
  count  = 1
  domain = "vpc"
}


# Nat Gateway
resource "aws_nat_gateway" "mern-estate-nat" {
  allocation_id = aws_eip.mern-estate-eip[0].id
  subnet_id     = aws_subnet.mern-estate-public-subnet[0].id

  tags = {
    Name = "mern-estate-nat"
  }
  depends_on = [aws_internet_gateway.mern-estate-igw]
}


# Internet Gateway
resource "aws_internet_gateway" "mern-estate-igw" {
  vpc_id = aws_vpc.mern-estate-vpc.id

  tags = {
    Name = "mern-estate-igw"
  }
}


# Public Route Table
resource "aws_route_table" "mern-estate-public-rt" {
  vpc_id = aws_vpc.mern-estate-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mern-estate-igw.id
  }

  tags = {
    Name = "mern-estate-public-rt"
  }
}

# Private Route Table
resource "aws_route_table" "mern-estate-private-rt" {
  vpc_id = aws_vpc.mern-estate-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mern-estate-nat.id 
  }

  tags = {
    Name = "mern-estate-private-rt"
  }
}


# Public Route Table Association
resource "aws_route_table_association" "mern-estate-public-rt-association" {
  count          = length(aws_subnet.mern-estate-public-subnet)
  subnet_id      = aws_subnet.mern-estate-public-subnet[count.index].id
  route_table_id = aws_route_table.mern-estate-public-rt.id
}


# Private Route Table Association
resource "aws_route_table_association" "mern-estate-private-rt-association" {
  count          = length(aws_subnet.mern-estate-private-subnet)
  subnet_id      = aws_subnet.mern-estate-private-subnet[count.index].id
  route_table_id = aws_route_table.mern-estate-private-rt.id
}

# Security Groups
resource "aws_security_group" "mern-estate-sg" {
  name        = "mern-estate-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.mern-estate-vpc.id

  tags = {
    Name = "mern-estate-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.mern-estate-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.mern-estate-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.mern-estate-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_ecr_repository" "app" {
  name = "mern-estate-repo"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

