terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-s3-website-lab"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "this" {
  for_each = var.students
  bucket   = "is311-website-hosting-${each.key}"

  tags = {
    Owner = each.value.name
  }
  lifecycle {
    ignore_changes = [
      website,
      website_domain,
      website_endpoint,
      versioning,
      policy,
    ]
  }

}