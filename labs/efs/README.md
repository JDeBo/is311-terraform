# EC2 Lab for Groups
This lab provisions EC2 instances for students to use in small groups. The instances used are Amazon Linux 2, at the t2.micro size (free tier elligible).


## Usage
To update instance types or sizes, edit main.tf

```bash
terraform init 

# runs a speculative plan showing users to be created
terraform plan --var count=1 #update count to desired number of groups

# performs an apply to generate resources
terraform apply --var count=1

# destroys the resources created in the apply
terraform destroy
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)