

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
sudo yum install mariadb-server
sudo systemctl enable mariadb
sudo systemctl start mariadb

echo "[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
bind-address=0.0.0.0
symbolic-links=0

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

\!includedir /etc/my.cnf.d" | sudo tee /etc/my.cnf > /dev/null

EOF

  user_data_replace_on_change = true
  tags = {
    Name = "is311-networking-mysql-server"
  }
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
