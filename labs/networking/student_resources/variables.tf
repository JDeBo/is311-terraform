variable "aws_userid" {
  description = "For SSO, needs to be an aws username matching the pattern ROLEUNIQUEID:caller-name eg. AROAU6CWOEXAMPLE:example@gmail.com"
  type        = string
}

variable "student_id" {
  description = "Id for student resources following patter firstname-lastname eg. john-smith"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to create networking resources in."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR Range for subnet."
}

variable "instance_profile" {
  description = "Instance profile to attach to EC2 instance"
}

variable "vpc_cidr" {
  description = "CIDR Range for the VPC"
}

variable "instance_name" {
  description = "Name for the instance"
}