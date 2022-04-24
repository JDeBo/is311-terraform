resource "aws_security_group" "lab" {
  for_each    = var.students
  name        = "is311-networking-${each.key}"
  description = "Networking Lab student subnet"
  vpc_id      = aws_vpc.networking_lab.id

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "is311-networking-${each.key}"
    Owner = each.key
  }
}
