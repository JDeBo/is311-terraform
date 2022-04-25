resource "aws_vpc" "networking_lab" {
  cidr_block = "172.32.0.0/16"

  tags = {
    Name = "networking-lab-vpc"
  }
}

module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"
  base_cidr_block = aws_vpc.networking_lab.cidr_block
  networks = [for x in keys(var.students) : {"name" = x, "new_bits" = 10}]
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = aws_vpc.networking_lab.id
  service_name = "com.amazonaws.us-east-2.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [for x in values(module.students) : x.security_group_id]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id       = aws_vpc.networking_lab.id
  service_name = "com.amazonaws.us-east-2.ec2messages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [for x in values(module.students) : x.security_group_id]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id       = aws_vpc.networking_lab.id
  service_name = "com.amazonaws.us-east-2.ssmmessages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [for x in values(module.students) : x.security_group_id]
}