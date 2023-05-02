data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

# https://wiki.debian.org/Cloud/AmazonEC2Image/Bullseye
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["136693071363"] # Debian

  filter {
    name   = "name"
    values = ["debian-11-amd64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}


data "aws_ami" "netsim" {
  #   executable_users = ["self"]
  most_recent = true
  #   name_regex       = "^minecrafty-\\d{3}"
  owners = ["self"]

  filter {
    name   = "name"
    values = ["netsim-*"]
  }
}