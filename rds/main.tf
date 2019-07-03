resource "aws_db_instance" "default_rds" {
  identifier                 = "${var.identifier}"
  allocated_storage           = "${var.storage}"
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.6"
  instance_class              = "${var.instance_class}"
  name                        = "${var.name}"
  username                    = "root"
  password                    = "${var.password}"
  parameter_group_name        = "default.mysql5.6"
  backup_retention_period     = "${var.backup_retention_period}"
  backup_window               = "${var.backup_window}"
  auto_minor_version_upgrade  = true
  maintenance_window          = "${var.maintenance_window}"
  copy_tags_to_snapshot       = true

  tags {
    Name           = "${var.teamid}-${var.name}"
    teamid         = "${var.teamid}"
    serviceid      = "${var.serviceid}"
    Email          = "${var.email}"
    Environment    = "${var.environment}"
    Vertical       = "${var.vertical}"
    Stack          = "${var.stack}"
  }
}