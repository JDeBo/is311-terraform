resource "aws_iam_user_policy_attachment" "efs" {
  user       = aws_iam_user.student.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess"
}