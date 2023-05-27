output "dns_names" {
  value = [for v in aws_route53_zone.students : v.name ]
}