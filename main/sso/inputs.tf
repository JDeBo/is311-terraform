variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "justin-debo" = {
    "first_name"       = "DeBo"
    "last_name"       = "DeBo"
    "email"      = "jdebo@millikin.edu"
  } }
}