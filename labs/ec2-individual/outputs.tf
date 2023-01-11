output "instance_map" {
  value = { for k, v in aws_instance.lab : k => v.id }
}

output "security_group" {
  value     = aws_security_group.allow_ssh.id
  sensitive = false
}