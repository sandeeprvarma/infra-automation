# the following outputs are required for the list_instances script to work
output "aws_profile" {
  value = "${module.aws.aws_profile}"
}

output "dc" {
  value = "${var.dc}"
}

output "aws_region" {
  value = "${module.aws.aws_region}"
}

output "iam_instance_role" {
  value = "${module.aws.iam_instance_profile}"
}

output "serviceid" {
  value = "${var.serviceid}"
}
#---------------------------------------------------------------------------
# Place any additional outputs here

