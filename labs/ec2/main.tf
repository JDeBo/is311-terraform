terraform {
  backend "s3" {
    bucket = "terraform-remote-state-932196253170"
    key    = "is-311-ec2-in-class"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
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
  count         = var.instance_count
  ami           = data.aws_ami.linux_2.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Group-${count.index+1}"
  }

  depends_on = [
    aws_security_group.allow_ssh
  ]
}

resource "aws_key_pair" "key_pair" {
  key_name   = "terraform_key"
  public_key = var.rsa_public_key
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}