variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "justin-debo" = {
    "name"       = "Justin DeBo"
    "email"      = "jdebo@millikin.edu"
    "keybase_id" = "jdebomillikin"
  } }
}

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