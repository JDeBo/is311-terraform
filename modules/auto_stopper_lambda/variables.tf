variable "rsa_public_key" {
  description = "Public key used to create key pair"
}

variable "use_case" {
  description = "Unique identifier for the use case the EC2 instances are created for. (Must be CamelCase)"
}

variable "ec2_map" {
  description = "Map of ec2 instances to associate to the lambda"
}