terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-dns-lab"
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

resource "aws_route53_zone" "main" {
  name = "is311.justindebo.com"
}

resource "aws_route53_record" "www-live" {
  count = 3
  zone_id = aws_route53_zone.main.zone_id
  name    = "site${count.index+1}"
  type    = "CNAME"
  ttl     = 60

  records        = ["http://is311-sites.s3-website.us-east-2.amazonaws.com/site${count.index+1}"]
}

resource "aws_route53_zone" "students" {
  for_each = var.students
  name = "${lower(each.value.firstname)}-${lower(each.value.lastname)}.${aws_route53_zone.main.name}"

  tags = {
    Owner = "${data.aws_iam_role.sso.unique_id}:${each.value.email}"
  }
}

resource "aws_route53_record" "students" {
  for_each = aws_route53_zone.students
  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = "NS"
  ttl     = "30"
  records = each.value.name_servers
}