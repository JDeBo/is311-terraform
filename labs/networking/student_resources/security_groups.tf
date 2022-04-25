resource "aws_security_group" "this" {
  name        = "is311-networking-${var.student_id}"
  description = "Networking Lab student subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "is311-networking-${var.student_id}"
    Owner = var.student_id
  }
}