output "access_key_map" {
  value = { for k, v in module.student_iam : k => v.access_key }
}

output "secret_access_key_map" {
  value     = { for k, v in module.student_iam : k => v.secret_access_key }
  sensitive = true
}

output "encrypted_password_map" {
  value     = { for k, v in module.student_iam : k => v.encrypted_password }
  sensitive = true
}

resource "local_file" "student" {
  sensitive_content = jsonencode({ for k, v in module.student_iam : k => v })
  filename          = "${path.module}/students.txt"
}

resource "local_file" "teacher" {
  sensitive_content = jsonencode({ for k, v in module.teacher_iam : k => v })
  filename          = "${path.module}/students.txt"
}