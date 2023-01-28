variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "justin-debo" = {
    "name"       = "Justin DeBo"
    "email"      = "jdebo@millikin.edu"
    "keybase_id" = "jdebomillikin"
  } }
}

variable "rsa_public_key" {
  description = "Public key used to create key pair"
}
