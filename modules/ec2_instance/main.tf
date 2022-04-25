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
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_list
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.instance_profile

  tags = {
    Name = var.name
  }
}
