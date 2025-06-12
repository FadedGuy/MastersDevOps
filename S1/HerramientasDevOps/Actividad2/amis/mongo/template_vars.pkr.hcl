variable "access_key" {
  type    = string
  default = "AKIAS3HZXV2VGIQKUVII"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "secret_key" {
  type    = string
  default = "56XBdpJ25Kx+oxh0SNDJbVB4k4VmZ0/RlQZ6CJa8"
}

variable "source_ami" {
  type    = string
  default = "ami-0d1b5a8c13042c939"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "app_name" {
  type    = string
  default = "mongo"
}

variable "app_version" {
  type    = string
  default = "1.0.0"
}
