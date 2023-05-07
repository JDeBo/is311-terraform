module "ec2" {
  source                  = "./../../../modules/ec2_instance"
  instance_name           = var.instance_name
  subnet_id               = aws_subnet.this.id
  vpc_security_group_list = [aws_security_group.this.id]
  instance_profile        = var.instance_profile
  aws_userid              = var.aws_userid
}

locals {
  tags = {
    Owner = var.aws_userid
    Name  = "networking-final-${var.student_id}"

  }
}