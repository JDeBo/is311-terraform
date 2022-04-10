resource "aws_iam_user_policy_attachment" "elb" {
  user       = aws_iam_user.student.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}