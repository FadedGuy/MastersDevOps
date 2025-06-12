variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Bloques CIDR para subnet publica"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Bloques CIDR para subnet privada"
  type        = list(string)
}

variable "availability_zones" {
  description = "Zonas de disponibilidad"
  type        = list(string)
}
