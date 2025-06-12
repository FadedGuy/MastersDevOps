variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Lista de CIDRs para las subredes públicas"
  type        = list(string)
}

variable "app_sg_id" {
  description = "SG para las instancias app"
  type        = string
}

variable "alb_sg_id" {
  description = "SG para el ALB"
  type        = string
}

variable "target_instance_ids" {
  description = "Lista de IDs de instancias EC2 para el target group"
  type        = map(string)
}
