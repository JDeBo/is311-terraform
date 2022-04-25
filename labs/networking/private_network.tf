

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.networking_lab.id
  cidr_block        = "172.32.12.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Lab Public Subnet"
  }

  depends_on = [module.students]
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.networking_lab.id

  route {
    cidr_block = "3.16.146.0/29" #AWS EC2_INSTANCE_CONNECT for us-east-2 check https://ip-ranges.amazonaws.com/ip-ranges.json for other regions
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

module "ec2" {
  source                  = "./../../modules/ec2_instance"
  name                    = "is311-networking-mysql-instance"
  subnet_id               = aws_subnet.this.id
  vpc_security_group_list = [aws_security_group.this.id]
  instance_profile        = aws_iam_instance_profile.this.id
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
