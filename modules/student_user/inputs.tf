variable "first_name" {
  description = "First name of student to create user for. eg. Bob"
  type        = string
}

variable "last_name" {
  description = "Last name of student to create user for.. eg. Smith"
  type        = string
}

variable "email" {
  description = "Email for "
}

variable "identity_store_id" {
  description = "ID for the SSO identity store of the account"
}