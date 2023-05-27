# DNS Lab for individual students
This lab provisions Route53 Hosted for students to use as well as a preconfigured S3 bucket that is sure to work given a properly uploaded index.html file. Each hosted zone costs $0.50 per month


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

## Recommended Lab Instructions

- Copy website files from
- Ensure that website comes up on the S3 side
- Setup A record in hosted zone to point to S3 site

## Grading

The following commands check the majority of the key objectives of the lab (bats tests coming later)
```sh
sudo yum list installed | grep httpd
sudo systemctl status httpd
ls /var/www/html/
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)