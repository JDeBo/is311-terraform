variable "subnet_id" {
  description = "The subnet ID to deploy the ec2 instance to"
  default     = null
}

variable "vpc_security_group_list" {
  description = "List of security groups to attach to the ec2 instances"
  default     = []
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.nano"
}

variable "aws_userid" {
  description = "For SSO, needs to be an aws username matching the pattern ROLEUNIQUEID:caller-name eg. AROAU6CWOEXAMPLE:example@gmail.com"
}

variable "instance_name" {
  description = "Name for the instance"
}

variable "instance_profile" {
  description = "Instance profile to attach to EC2 instance"
  default     = null
}