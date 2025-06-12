variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Lista de IDs de subnet publicas"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Lista de IDs de subnet privadas"
  type        = list(string)
}

variable "mongo_ami_name_tag" {
  description = "Tag de nombre para la AMI de mongo"
  type        = string
}

variable "app_ami_name_tag" {
  description = "Tag de nombre para la AMI de la app"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nombre del key pair para SSH"
  type        = string
}

variable "app_sg_id" {
  description = "SG ID para la instancia app"
  type        = string
}

variable "mongodb_sg_id" {
  description = "SG ID para la instancia mongo"
  type        = string
}
