data template_file "userdata_template" {
  template = "${file("${path.module}/templates/userdata.tpl")}"
  vars = {
    git_repo_url    = "${var.git_repo_url}"
    brach_name      = "${var.brach_name}"
    provision_file  = "${var.provision_file}"
    inventory       = "${var.inventory}"
    host_name       = "${var.host_name}"
  }
}

data "aws_acm_certificate" "certificate" {
  domain      = "labs.gracenote.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}


resource "aws_instance" "ec2" {
  vpc_security_group_ids = [
                             "${module.aws.default_sg}",
                             "${module.aws.common_sg["WebserverInternal"]}"
                           ]

  # specify which AZ to deploy instance.  0 = 1st AZ, 1 = 2nd AZ, 2 = 3rd AZ
  subnet_id              = "${element(module.aws.private_subnets, 0)}"

  #---------------------------------------------------------------
  # shouldn't need to change anything below
  #---------------------------------------------------------------
  ami                    = "${module.aws.gn_latest_ubuntu_id}"
  instance_type          = "${var.inst_type}"
  key_name               = "${var.key_name}"

  # don't change the instance profile, otherwise you'll get an error
  iam_instance_profile   = "${module.aws.iam_instance_profile}"

  root_block_device {
    volume_type = "${var.root_volume_type}"
    volume_size = "${var.root_volume_size}"
  }

  tags {
    Name           = "${var.teamid}-${var.inst_name}"
    teamid         = "${var.teamid}"
    serviceid      = "${var.serviceid}"
    Email          = "${var.email}"
    Environment    = "${var.environment}"
    Vertical       = "${var.vertical}"
    Stack          = "${var.stack}"
  }

  volume_tags {
    Name           = "${var.teamid}-${var.serviceid}"
    teamid         = "${var.teamid}"
    serviceid      = "${var.serviceid}"
    Email          = "${var.email}"
    Environment    = "${var.environment}"
    Vertical       = "${var.vertical}"
    Stack          = "${var.stack}"
  }

  user_data = "${data.template_file.userdata_template.rendered}"
}


# resource "null_resource" "cluster" {
#   count = "${var.enable_provision}"
#   provisioner "remote-exec" {
#     inline = ["echo 'Connected Successfully!'"]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       host        = "${aws_instance.ec2.private_ip}"
#       private_key = "${file("${var.private_key_path}")}"
#     }
#   }

#   provisioner "local-exec" {
#     # command = "echo ${aws_instance.ec2.private_ip} >> private_ips.txt"
#     # command = "ansible-playbook ../ansible/provision.yml --user=ubuntu --key-file=../superuserepgs --inventory-file=../ansible/inventory/staging"
#     command = "ansible-playbook -i '${aws_instance.ec2.private_ip},' --private-key ${var.private_key_path} ../ansible/provision.yml"
#   }
# }

# Create a new load balancer
resource "aws_elb" "epgslb" {
  name               = "${var.elb_name}"
  security_groups    = ["${module.aws.common_sg["WebserverExternal"]}"]
  subnets            = ["${module.aws.public_subnets}"]
  
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.certificate.arn}"
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  instances                   = ["${aws_instance.ec2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name           = "${var.teamid}-${var.serviceid}"
    teamid         = "${var.teamid}"
    serviceid      = "${var.serviceid}"
    Email          = "${var.email}"
    Environment    = "${var.environment}"
    Vertical       = "${var.vertical}"
    Stack          = "${var.stack}"
  }
}

data "aws_route53_zone" "hosted_zone" {
  name         = "${var.hosted_zone}"
  private_zone = "false"
}

resource "aws_route53_record" "epgs-routes" {
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name    = "${var.elb_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.epgslb.dns_name}"
    zone_id                = "${aws_elb.epgslb.zone_id}"
    evaluate_target_health = true
  }
}
