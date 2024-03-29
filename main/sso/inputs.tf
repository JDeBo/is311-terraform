variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "justin-debo" = {
    "firstname" = "DeBo"
    "lastname"  = "DeBo"
    "email"     = "jdebo@millikin.edu"
  } }
}

variable "target_account_id" {
  description = "Target account for giving student group access"
  type        = string

  validation {
    condition     = length(var.target_account_id) == 12
    error_message = "The Target Account ID value must be a valid 12 digit account ID."
  }
}

variable "region" {
  description = "Region for IAM permissions"
  default     = "us-east-2"
}