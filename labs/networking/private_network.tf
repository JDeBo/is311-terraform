

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.networking_lab.id
  cidr_block        = "172.32.12.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Lab private Subnet"
  }

  depends_on = [module.students]
}

resource "aws_eip" "this" {}


resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.this.id

  tags = {
    Name = "Lab NAT GW"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.networking_lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "Lab Private Route Table"
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

resource "aws_security_group" "this" {
  name        = "is311-networking-private-instance"
  description = "Networking Lab private instance subnet"
  vpc_id      = aws_vpc.networking_lab.id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.networking_lab.cidr_block]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.networking_lab.cidr_block]
  }

  egress {
    description = "Https to Anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "is311-networking-private-instance"
  }

  lifecycle {
    create_before_destroy = true
  }
}
