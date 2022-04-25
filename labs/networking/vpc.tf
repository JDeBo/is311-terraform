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