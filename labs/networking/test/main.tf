variable "students" {
  description = "Map of students to create users for."
  type        = map(map(string))
  default = { "justin-debo" = {
    "name"       = "Justin DeBo"
    "email"      = "jdebo@millikin.edu"
    "keybase_id" = "jdebomillikin"
  } 
   "justin-debo1" = {
    "name"       = "Justin DeBo"
    "email"      = "jdebo@millikin.edu"
    "keybase_id" = "jdebomillikin"
  }
   "justin-debo2" = {
    "name"       = "Justin DeBo"
    "email"      = "jdebo@millikin.edu"
    "keybase_id" = "jdebomillikin"
  }}
}

module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"
  base_cidr_block = "172.32.0.0/16"
  networks = [for x in keys(var.students) : {"name" = x, "new_bits" = 16}]
}

output "subnets" {
  value = module.subnets.networks
}