variable "rsa_public_key" {
  description = "Public key used to create key pair"
  type = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create for lab"
}

variable "vpc_id" {
  description = "The VPC ID for security group to connect to"
  type = string
}