# S3-Website Lab
This lab provisions S3 buckets for students to use in creating a static website. The buckets come pre-provisioned with the correct access requirements for hosting static sites.


## Usage

```bash
terraform init 

# runs a speculative plan showing users to be created
terraform plan --var-file=students.tfvars

# performs an apply to generate resources
terraform apply

# destroys the resources created in the apply
terraform destroy
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)