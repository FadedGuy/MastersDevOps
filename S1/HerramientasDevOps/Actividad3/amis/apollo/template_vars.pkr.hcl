#  SEGURIDAD MEJORADA - Variables sin credenciales hardcodeadas
variable "access_key" {
  type        = string
  description = "AWS Access Key - Set via environment variable: export PKR_VAR_access_key=YOUR_KEY"
  #  REMOVIDO: default con credenciales expuestas
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key - Set via environment variable: export PKR_VAR_secret_key=YOUR_SECRET"
  sensitive   = true
  #  REMOVIDO: default con credenciales expuestas
}

variable "instance_type" {
  type    = string
  default = "t3.medium"  #  MEJORADO: t3.medium para mejor performance
}

variable "region" {
  type    = string
  default = "us-east-1"  #  MEJORADO: us-east-1 para mejor disponibilidad
}

variable "source_ami" {
  type    = string
  default = "ami-0a7d80731ae1b2435"  #  Ubuntu 24.04 LTS más reciente
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "app_name" {
  type    = string
  default = "apollo-fintech"
}

variable "app_version" {
  type    = string
  default = "1.0.0"
}

#  NUEVAS VARIABLES para integración ELK
variable "elk_server_ip" {
  type        = string
  description = "IP del servidor ELK Stack para APM y Beats"
  default     = "10.0.1.200"  # IP privada por defecto
}
