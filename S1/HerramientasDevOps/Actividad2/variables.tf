variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs para las subredes públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDRs para las subredes privadas"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "mongo_ami_name_tag" {
  description = "AMI generada por Packer de mongo"
  type        = string
  default     = "mongo"
}

variable "app_ami_name_tag" {
  description = "AMI generada por Packer de la aplicacion"
  type        = string
  default     = "app"
}

variable "instance_type" {
  description = "Tipo de instancia a usar"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Clave-valor del par de llaves generadas para la conexion ssh"
  type        = string
  default     = "actividad2_terraform"
}
