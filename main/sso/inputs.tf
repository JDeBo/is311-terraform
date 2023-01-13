variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "justin-debo" = {
    "first_name" = "DeBo"
    "last_name"  = "DeBo"
    "email"      = "jdebo@millikin.edu"
  } }
}

variable "target_account_id" {
  description = "Target account for giving student group access"
  type        = string

  validation {
    condition     = length(var.target_account_id) == 12
    error_message = "The Target Account ID value must be a valid 12 digit account ID"
  }
}