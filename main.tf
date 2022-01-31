terraform {
  backend "s3" {
    bucket = "terraform-remote-state-932196253170"
    key    = "is-311"
    region = "us-east-2"
  }
}

provider "aws" {
    region = "us-east-2"
}

