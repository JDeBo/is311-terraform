terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.74.0"
    }
    local = {
      version = "~> 2.1"
    }
  }

  required_version = ">= 1.0"
}