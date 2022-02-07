variable "student_name" {
  description = "name of student to create user for. eg. Bob Smith"
  type        = string
}

variable "student_resource_id" {
  description = "Resource friendly version of student name. eg. bob-smith"
}

variable "keybase_id" {
  description = "ID for a Keybase user"
}