variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "justin-debo" = {
    "name"       = "Justin DeBo"
    "email"      = "jdebo@millikin.edu"
    "keybase_id" = "jdebomillikin"
  } }
}

variable "vpc_id" {
  description = "The VPC ID for security group to connect to"
}