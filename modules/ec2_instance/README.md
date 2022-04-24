# EC2
This module creates an EC2 instance. The instances use Amazon Linux 2, and default to the t3.nano size.


## Usage
To update instance types or sizes, edit main.tf

```hcl
module "individual_ec2s" {
  source =          "../modules/ec2_instance"
  name =            "my-ec2-instance"
  instance_type =   "t2.micro"
  subnet_id =       "my-subnet-id123"
}
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)