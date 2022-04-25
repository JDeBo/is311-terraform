resource "aws_subnet" "this" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr
  availability_zone = "us-east-2a"

  tags = {
    Name  = "is311-networking-${var.student_id}"
    Owner = var.student_id
  }
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  route  = []

  tags = {
    Name  = "is311-networking-${var.student_id}"
    Owner = var.student_id
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}
