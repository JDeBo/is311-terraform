terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-efs-lab"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "tfe_outputs" "is311_ec2" {
  organization = "jdebo-automation"
  workspace = "is311-ec2-individual-lab"
}

resource "aws_efs_file_system" "this" {
  availability_zone_name = "us-east-2c"
  tags = {
    Name = "is311-file-system"
  }
}

resource "aws_efs_mount_target" "this" {
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = aws_default_subnet.default_use2c.id
  security_groups = [aws_security_group.allow_nfs.id]
}

resource "aws_default_subnet" "default_use2c" {
  availability_zone = "us-east-2c"

  tags = {
    Name = "Default subnet for us-east-2c"
  }
}
resource "aws_security_group" "allow_nfs" {
  name        = "allow_nfs"
  description = "Allow NFS inbound traffic from EC2 sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "EC2 to EFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    # security_groups = [data.tfe_outputs.is311_ec2.values.security_group]
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_nfs"
  }
}