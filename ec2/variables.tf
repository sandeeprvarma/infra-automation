variable "ami_id" {
  default = "ami-0b37e9efc396e4c38" #Ubuntu Server 16.04 LTS (HVM), SSD Volume Type Free tier eligible
  description = "ami id of the OS image. we can create our own amis"
}

variable "region" {
  type = "string"
  default = "us-west-2"
  description = "describe your variable"
}

variable "inst_name" {
  type = "string"
  description = "describe your variable"
}

variable "environment" {
  type = "string"
  description = "describe your variable"
}
variable "inst_type" {
  type = "string"
  default = "t2.micro"
  description = "describe your variable"
}
variable "key_name" {
  default = "sandeep"
  description = "describe your variable"
}

variable "root_volume_type" {
  default = "gp2"
  description = "Can be standard or gp2"
}
variable "root_volume_size" {
  default = 8
  description = "In gigabytes, must be at least 8"
}