resource "aws_iam_user" "student" {
  name          = var.student_resource_id
  force_destroy = true
}

resource "aws_iam_access_key" "student" {
  user    = aws_iam_user.student.name
}

# resource "aws_iam_user_login_profile" "example" {
#   user    = aws_iam_user.student.name
#   pgp_key = "keybase:some_person_that_exists"
#   password_length = 8
#   password_reset_required = true
# }
#   lifecycle {
#     ignore_changes = [
#       password_length,
#       password_reset_required,
#       pgp_key,
#     ]
#   }