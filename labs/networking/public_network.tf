resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.networking_lab.id

  tags = {
    Name = "Main Lab Internet Gateway"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.this.id

  tags = {
    Name = "Lab NAT GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}

resource "aws_eip" "this" {}

resource "aws_subnet" "this" {
  vpc_id = aws_vpc.networking_lab.id
  cidr_block        = "172.32.12.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Lab Public Subnet"
  }

  depends_on = [module.students]
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.networking_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "Lab Public Route Table"
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

module "ec2" {
  source = "./../../modules/ec2_instance"
  name = "is311-networking-public-instance"
  subnet_id = aws_subnet.this.id
  vpc_security_group_list = [aws_security_group.this.id]
}

resource "aws_security_group" "this" {
  name        = "is311-networking-public-instance"
  description = "Networking Lab public instance subnet"
  vpc_id      = aws_vpc.networking_lab.id

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "is311-networking-public-instance"
  }
}
