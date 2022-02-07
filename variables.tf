variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "justin-debo" = {
    "name"       = "Justin DeBo"
    "email"      = "jdebo@millikin.edu"
    "keybase_id" = "jdebomillikin"
  } }
}

variable "teachers" {
  description = "Map of teachers to create users for."
  type        = map(map(string))
  default = { "" = {
    "name"       = ""
    "email"      = ""
    "keybase_id" = ""
  } }
}