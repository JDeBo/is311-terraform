output "access_key" {
  value = aws_iam_access_key.student.id
}

output "secret_access_key" {
  value = aws_iam_access_key.student.encrypted_secret
}

output "password" {
  value = aws_iam_user_login_profile.student.password
}