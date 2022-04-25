variable "subnet_id" {
  description = "The subnet ID to deploy the ec2 instance to"
  default = ""
}

variable "vpc_security_group_list" {
  description = "List of security groups to attach to the ec2 instances"
  default = []
}

variable "instance_type" {
  description = "Instance type"
  type = string
  default = "t3.nano"
}

variable "name" {
  description = "Name of the ec2 instance"
}

variable "instance_profile" {
  description = "Instance profile to attach to EC2 instance"
  default = ""
}