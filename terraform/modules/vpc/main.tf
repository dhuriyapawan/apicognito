# VPC
resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name ="${var.environment}-vpc"
        Environment = var.environment
    }
}

# Public Subnets
resource "aws_subent" "public" {
    count = length(var.public_subnet_cidrs)

    vpc_id  = aws_vpc.this.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone  = var.azs [count.index]
    map_public_ip_on_launch = true

    tags ={
        Name ="${var.environment}-public-${count.index+1}"
        Environment = var.environment
        Type = "Public"
    }
}

# Private
resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws.vpc.this.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.azs[count.index]

    tags = {
    Name        = "${var.environment}-private-${count.index + 1}"
    Environment = var.environment
    Type        = "private"
  }
}
# =========================
# Internet Gateway
# =========================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# =========================
# Elastic IP for NAT
# =========================
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip"
  }
}

# =========================
# NAT Gateway
# =========================
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.environment}-nat"
    Environment = var.environment
  }
}

# =========================
# Public Route Table
# =========================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

# =========================
# Private Route Table
# =========================
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "${var.environment}-private-rt"
    Environment = var.environment
  }
}

# =========================
# Public Route Table Association
# =========================
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# =========================
# Private Route Table Association
# =========================
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}