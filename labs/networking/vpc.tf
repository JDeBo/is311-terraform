resource "aws_vpc" "networking_lab" {
  cidr_block = "172.32.0.0/16"

  tags = {
    Name = "networking-lab-vpc"
  }
}

module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"
  base_cidr_block = networking_lab.cidr_block
  networks = [for x in keys(var.students) : {"name" = x, "new_bits" = 16}]
}

resource "aws_subnet" "student_subnets" {
  for_each          = module.subnets.networks
  vpc_id            = aws_vpc.networking_lab.id
  cidr_block        = each.value.cidr_block
  availability_zone = "us-east-2a"

  tags = {
    Name = "is311-networking-${each.value.name}"
  }
}

