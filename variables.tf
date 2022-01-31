variable "students" {
  description = "list of students to create users for."
  type = list(object({
      name = string
      resource-name = string
  }))
  default = [ {
    name = "Justin DeBo"
    resource-name = "justin-debo"
  } ]
}