output "dns_names" {
  value = jsonencode({ for k, v in aws_route53_zone.students : k => v.name })
}