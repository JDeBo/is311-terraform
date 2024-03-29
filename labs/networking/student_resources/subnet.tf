resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = local.tags

}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  route  = []

  tags = local.tags

  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}
