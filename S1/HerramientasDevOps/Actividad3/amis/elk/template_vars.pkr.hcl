#  SEGURIDAD MEJORADA - Variables sin credenciales hardcodeadas
variable "access_key" {
  type        = string
  description = "AWS Access Key - Set via environment variable: export PKR_VAR_access_key=YOUR_KEY"
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key - Set via environment variable: export PKR_VAR_secret_key=YOUR_SECRET"
  sensitive   = true
}

variable "instance_type" {
  type    = string
  default = "t3.large"  #  ELK Stack necesita más recursos
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "source_ami" {
  type    = string
  default = "ami-0a7d80731ae1b2435 "  #  Ubuntu 24.04 LTS más reciente
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "app_name" {
  type    = string
  default = "elk-apm-stack"
}

variable "app_version" {
  type    = string
  default = "1.0.0"
}
