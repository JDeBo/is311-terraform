resource "aws_iam_group" "students" {
  name = "students"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "vpc_read" {
  group      = aws_iam_group.students.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "elb" {
  group      = aws_iam_group.students.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

resource "aws_iam_user_policy_attachment" "ec2_read" {
  user       = aws_iam_user.student.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "efs" {
  user       = aws_iam_user.student.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess"
}