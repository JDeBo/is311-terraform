terraform {
  backend "s3" {
    bucket = "terraform-remote-state-932196253170"
    key    = "is-311-s3-in-class"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

data "terraform_remote_state" "master" {
  backend = "s3"

  config = {
    bucket = "terraform-remote-state-932196253170"
    key    = "is-311"
    region = "us-east-2"
  }
}

resource "aws_s3_bucket" "this" {
  for_each = data.terraform_remote_state.master.outputs.student_list
  bucket = "is311-website-hosting-${each.value}"

  tags = {
    Owner        = each.key
  }
  
}