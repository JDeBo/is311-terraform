# S3-Website Lab
This lab provisions S3 for students to use. The buckets are set up without any acls, iam permissions or public access settings.

## Lab recommendations
For this lab, I have students create a static site using free templates from [HTML5UP](https://html5up.net). If you curious what the full lab looks like, you can view my assignment instructions [here](https://docs.google.com/document/d/1s4BDTiMX9OqwlJzCjLCG-u-5MCoTWUTpDecmmtjF2VA/edit?usp=sharing)

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