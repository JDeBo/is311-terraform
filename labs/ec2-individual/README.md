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

## Recommended Lab Instructions

- Pull website files from S3 bucket (`wget --recursive --no-parent s3://files-location`)
- Install Apache Web Server (`sudo yum install httpd`)
- Move files into `/var/www/html`
- Enable and then start `httpd` using `systemctl` (eg. `systemctl start` & `systemctl enable`)
- Ensure web server comes up after instance restart

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