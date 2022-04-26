

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.networking_lab.id
  cidr_block        = "172.32.12.0/24"
  availability_zone = "us-east-2a"

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

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.networking_lab.id

  route {
    cidr_block = "0.0.0.0/0" #AWS EC2_INSTANCE_CONNECT for us-east-2 check https://ip-ranges.amazonaws.com/ip-ranges.json for other regions
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

data "aws_ami" "linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # AWS
}

resource "aws_instance" "lab" {
  ami                    = data.aws_ami.linux_2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = aws_subnet.this.id
  iam_instance_profile   = aws_iam_instance_profile.this.id
  user_data              = <<EOF
#!/bin/bash
sudo yum install mariadb-server -y
sudo systemctl enable mariadb

echo "[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
bind-address=0.0.0.0
symbolic-links=0

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

\!includedir /etc/my.cnf.d" | sudo tee /etc/my.cnf > /dev/null

sudo systemctl start mariadb
mysql -u root -e "CREATE USER 'student'@'%' IDENTIFIED BY 'password';"
echo "success"
EOF

  user_data_replace_on_change = true
  tags = {
    Name = "is311-networking-mysql-server"
  }
}

resource "aws_security_group" "this" {
  name        = "is311-networking-private-instance"
  description = "Networking Lab private instance subnet"
  vpc_id      = aws_vpc.networking_lab.id

  ingress {
    description = "MySQL from Anywhere"
    from_port   = 3306
    to_port     = 3306
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
