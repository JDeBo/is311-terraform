# is311-terraform
This is a Terraform repository for an introductory IT Infrastructure class. It contains modules to create IAM users for students and teachers with permissions scoped to the resources in the labs shown in the /labs directory.


## Setup

```bash
git clone git@github.com:JDeBo/is311-terraform.git [--recurse-submodules]
```

Students will need to create accounts at [keybase.io](https://keybase.io) in order to have their IAM users generated

All terraform in this repo assumes AWS access is set through exporting environment variables. See [AWS's Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

## Usage
These commands won't run with the sample users in students.tfvars and teachers.tfvars due to their fake keybase names

```bash
terraform init 

# runs a speculative plan showing users to be created
terraform plan --var-file=students.tfvars --var-file=teachers.tfvars -out=tfplan

# performs an apply to generate resources
terraform apply tfplan

# destroys the resources created in the apply
terraform destroy
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)