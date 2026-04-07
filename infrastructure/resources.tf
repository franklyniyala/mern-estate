# VPC
resource "aws_vpc" "mern-estate-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "mern-estate"
  }
}

# Subnet
resource "aws_subnet" "mern-estate-subnet" {
  vpc_id     = aws_vpc.mern-estate-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "mern-estate-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "mern-estate-igw" {
  vpc_id = aws_vpc.mern-estate-vpc.id

  tags = {
    Name = "mern-estate-igw"
  }
}


# Route Table
resource "aws_route_table" "mern-estate-rt" {
  vpc_id = aws_vpc.mern-estate-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mern-estate-igw.id
  }

  tags = {
    Name = "mern-estate-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "mern-estate-rt-association" {
  subnet_id      = aws_subnet.mern-estate-subnet.id
  route_table_id = aws_route_table.mern-estate-rt.id
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
