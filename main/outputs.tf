output "student_list" {
  value = keys(var.students)
}
# output "secret_access_key_map" {
#   value     = { for k, v in module.student_iam : k => v.secret_access_key }
#   sensitive = true
# }

# output "encrypted_password_map" {
#   value     = { for k, v in module.student_iam : k => v.encrypted_password }
#   sensitive = true
# }

output "student" {
  value = jsonencode({ for k, v in module.student_iam : k => v })
  # filename          = "${path.module}/students.json"
}

output "teacher" {
  value = jsonencode({ for k, v in module.teacher_iam : k => v })
  # filename          = "${path.module}/teachers.json"
}