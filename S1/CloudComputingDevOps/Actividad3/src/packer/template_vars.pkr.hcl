variable "access_key" {
  type    = string
  default = "AKIAS3HZXV2VGIQKUVII"
}

variable "secret_key" {
  type    = string
  default = "56XBdpJ25Kx+oxh0SNDJbVB4k4VmZ0/RlQZ6CJa8"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "source_ami" {
  type    = string
  default = "ami-0d1b5a8c13042c939"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "key_pair" {
  type    = string
  default = "Actividad3_CloudComputing"
}

variable "security_group" {
  type    = string
  default = "sg-06b05219a190afb26"
}

variable "app_name" {
  type    = string
  default = "cloudcomputing_act3"
}

variable "app_version" {
  type    = string
  default = "1.0.0"
}
