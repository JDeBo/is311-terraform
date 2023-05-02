module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "3.10.1"
  for_each      = var.students
  force_destroy = true

  bucket = "${lower(each.value.firstname)}-${lower(each.value.lastname)}.${aws_route53_zone.main.name}"
  #   acl      = "public-read"
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
  # Bucket policies
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy[each.key].json
}

data "aws_iam_policy_document" "bucket_policy" {
  for_each = var.students

  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${lower(each.value.firstname)}-${lower(each.value.lastname)}.${aws_route53_zone.main.name}/*",
    ]
  }
}
