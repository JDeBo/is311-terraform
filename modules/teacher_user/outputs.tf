output "access_key" {
  value = aws_iam_access_key.teacher.id
}

output "secret_access_key" {
  value = aws_iam_access_key.teacher.secret
}

output "encrypted_password" {
  value = aws_iam_user_login_profile.teacher.encrypted_password
}