output "instance_id" {
  value = module.ec2.instance_id
}

output "route_table_id" {
  value = aws_route_table.this.id
}

output "subnet_id" {
  value = aws_subnet.this.id
}

output "security_group_id" {
  value = aws_security_group.this.id
}