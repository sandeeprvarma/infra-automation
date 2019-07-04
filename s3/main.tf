provider "aws" {
  region    = "${var.aws_region}"
}

resource "aws_s3_bucket" "aws_s3" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  #Clean it up in 91 days
  # lifecycle_rule {
  #   id      = "cleanup"
  #   enabled = true

  #   expiration {
  #     days = 91
  #   }
  # }

  tags = "${local.common_tags}"
  /*
  We can also add new tags using below code
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "OpenShift Master"
    )
  )}"
  */
}