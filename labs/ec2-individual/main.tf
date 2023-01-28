terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-ec2-individual-lab"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_iam_roles" "sso" {
  name_regex  = ".*student.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

data "aws_vpc" "controltower" {
  filter {
    name   = "tag:Name"
    values = "*controltower*" #replace if you aren't using control tower
  }
}

# data "aws_ami" "linux_2" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm-2*-x86_64-gp2"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["137112412989"] # AWS
# }

# resource "aws_instance" "lab" {
#   for_each               = var.students
#   ami                    = data.aws_ami.linux_2.id
#   instance_type          = "t3.nano"
#   key_name               = aws_key_pair.key_pair.id
#   vpc_security_group_ids = [aws_security_group.allow_ssh.id]

#   tags = {
#     Name = "is311-${each.key}"
#   }

#   depends_on = [
#     aws_security_group.allow_ssh
#   ]
# }
module "instances" {
  source                  = "../../modules/ec2_instance"
  for_each                = var.students
  instance_type           = "t3.nano"
  vpc_security_group_list = [aws_security_group.allow_ssh.id]
  aws_userid              = "${data.aws_iam_roles.sso[0].unique_id}:${each.value.email}"
  key_pair_id             = aws_key_pair.key_pair.id
}

resource "aws_key_pair" "key_pair" {
  key_name   = "terraform_key"
  public_key = var.rsa_public_key
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.controltower.id

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
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
    Name = "allow_ssh"
  }
}
