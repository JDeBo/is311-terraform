variable "students" {
  description = "Map of students to create users for."
  type        = map(string)
  default     = { "justin-debo" : "Justin DeBo" }
}