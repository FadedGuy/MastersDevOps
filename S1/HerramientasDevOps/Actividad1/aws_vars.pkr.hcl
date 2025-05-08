variable "aws_access_key" {
  type    = string
  default = "AKIAS3HZXV2VGIQKUVII"
}

variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "aws_secret_key" {
  type    = string
  default = "56XBdpJ25Kx+oxh0SNDJbVB4k4VmZ0/RlQZ6CJa8"
}

variable "aws_source_ami" {
  type    = string
  default = "ami-04f167a56786e4b09"
}

variable "aws_ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "aws_security_group" {
  type = string
  default = "sg-0ab298dbfface9ac0"
}
