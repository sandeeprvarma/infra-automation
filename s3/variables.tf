variable "aws_region" {
  default = "us-west-2"
  description = "Specify region in which we want to create the rsourses"
}

variable "bucket_name" {
  type = "string"
  default = "test-bucket"
  description = "describe your variable"
}

variable "bucket_tag" {
  type = "string"
  description = "tag to uniquly get bucket for any further modification or billing info"
}

locals {
  common_tags = {
    Name        = "${var.bucket_tag}"
  }
}