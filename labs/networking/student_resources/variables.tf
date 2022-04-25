variable "student_id" {
  description = "ID of student in AWS."
  type        = string
  default     = "justin-debo"
}

variable "vpc_id" {
  description = "VPC ID to create networking resources in."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR Range for subnet."
}
