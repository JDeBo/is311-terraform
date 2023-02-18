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

data "aws_iam_roles" "sso" {
  name_regex  = ".*student.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

data "aws_iam_role" "sso" {
  name = tolist(data.aws_iam_roles.sso.names)[0]
}

resource "aws_s3_bucket" "this" {
  for_each = var.students
  bucket   = "is311-website-hosting-${lower(each.value.firstname)}-${lower(each.value.lastname)}"

  tags = {
    Owner = "${data.aws_iam_role.sso.unique_id}:${each.value.email}"
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