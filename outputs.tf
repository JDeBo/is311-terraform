# output "access_key_map" {
#   value = {for k, v in module.student_iam : k => v.access_key}
# }

# output "secret_access_key_map" {
#   value = {for k, v in module.student_iam : k => v.secret_access_key}
#   sensitive = true
# }

resource "local_file" "outputs" {
    sensitive_content     = jsonencode({for k, v in module.student_iam : k => v})
    filename = "${path.module}/secrets.txt"
}