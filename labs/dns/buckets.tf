module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.1"
  for_each = var.students
  bucket   = "${lower(each.value.firstname)}-${lower(each.value.lastname)}.${aws_route53_zone.main.name}"
  acl      = "public"
  website = {
    index_document = "index.html"
  }
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  versioning = {
    enabled = true
  }
}
