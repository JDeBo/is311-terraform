terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-dns-lab"
    }
  }
  required_version = ">= 1.3"

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

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = aws_route53_zone.main.name
  type    = "A"

  alias {
    name                   = data.aws_cloudfront_distribution.main.domain_name
    zone_id                = data.aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_cloudfront_distribution" "main" {
  id = "E2FUZ316LEW1C3"
}

resource "aws_route53_zone" "students" {
  for_each = var.students
  name = "${lower(each.value.firstname)}-${lower(each.value.lastname)}.${aws_route53_zone.main.name}"
  force_destroy = true

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