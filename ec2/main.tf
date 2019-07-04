
# Create a new instance of the latest Ubuntu 16.04 on an
# t2.micro node with an AWS Tag naming it "Test Server"
provider "aws" {
  region = "${var.region}"
}

#We can use existing ami using the below code 
# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-16.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["self"] # Canonical
# }

data template_file "userdata_template" {
  template = "${file("${path.module}/templates/userdata.tpl")}"
  vars = {
    # git_repo_url    = "${var.git_repo_url}" //in case you want to clone something after creating the instance
  }
}

# Create a new instance
resource "aws_instance" "ec2" {
  # ami           = "${data.aws_ami.ubuntu.id}"
  ami           = "${var.ami_id}"
  instance_type = "${var.inst_type}"
  key_name      = "${var.key_name}"

  tags = {
    Name = "${var.inst_name}"
  }

  #specify volume size and type default is: root_volume_type=gp; root_volume_size=8
  root_block_device {
    volume_type = "${var.root_volume_type}"
    volume_size = "${var.root_volume_size}"
  }

  user_data = "${data.template_file.userdata_template.rendered}"
}


