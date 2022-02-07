output "access_key" {
  value = aws_iam_access_key.student.id
}

output "secret_access_key" {
  value = aws_iam_access_key.student.secret
}

output "encrypted_password" {
  value = aws_iam_user_login_profile.student.encrypted_password
}