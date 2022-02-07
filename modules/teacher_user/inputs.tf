variable "teacher_name" {
  description = "name of teacher to create user for. eg. Bob Smith"
  type        = string
}

variable "teacher_resource_id" {
  description = "Resource friendly version of teacher name. eg. bob-smith"
}

variable "keybase_id" {
  description = "ID for a Keybase user"
}

variable "class_id" {
  description = "ID for the class that's being taught"
}