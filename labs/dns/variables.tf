variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "jdebo@millikin.edu" = {
    "firstname" = "Justin"
    "lastname"  = "DeBo"
    "email"     = "jdebo@millikin.edu"
  } }
}
