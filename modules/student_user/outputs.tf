output "access_key" {
  value = aws_iam_access_key.student.id
}

output "secret_access_key" {
  value = aws_iam_access_key.student.secret
}