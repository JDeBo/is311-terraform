variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "jdebo@millikin.edu" = {
    "firstname" = "Justin DeBo"
    "lastname"  = "Justin DeBo"
    "email"     = "jdebo@millikin.edu"
  } }
}
