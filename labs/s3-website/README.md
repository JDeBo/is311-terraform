# S3-Website Lab
This lab provisions S3 for students to use. The buckets are set up without any acls, iam permissions or public access settings.


## Usage
```bash
terraform init 

# runs a speculative plan showing users to be created
terraform plan

# performs an apply to generate resources
terraform apply

# destroys the resources created in the apply
terraform destroy
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)