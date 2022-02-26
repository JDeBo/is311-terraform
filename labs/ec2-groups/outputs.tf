output "instance_map" {
  value = { for k, v in aws_instance.lab : k => v.id }
}