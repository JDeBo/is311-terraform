terraform {
  cloud {
    organization = "jdebo-automation"
    workspaces {
      name = "is311-main"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# module "student_iam" {
#   source = "../modules/student_user"

#   for_each          = var.students
#   first_name        = each.value.first_name
#   last_name         = each.value.last_name
#   email             = each.value.email
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
# }

