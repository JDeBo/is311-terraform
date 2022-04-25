module "ec2" {
  source = "./../../../modules/ec2_instance"
  name = "is311-networking-${var.student_id}"
  subnet_id = aws_subnet.this.id
  vpc_security_group_list = [aws_security_group.this.id]
  instance_profile = var.instance_profile
}
