packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

#  VARIABLES DEFINIDAS AQUÍ
variable "access_key" {
  type        = string
  description = "AWS Access Key - Set via environment variable: export PKR_VAR_access_key=YOUR_KEY"
  default     = null
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key - Set via environment variable: export PKR_VAR_secret_key=YOUR_SECRET"
  sensitive   = true
  default     = null
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "source_ami" {
  type    = string
  default = "ami-0a7d80731ae1b2435"  # Ubuntu 24.04 LTS us-east-1
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

variable "elk_server_ip" {
  type        = string
  description = "IP del servidor ELK Stack para APM y Beats"
  default     = "10.0.1.200"
}

#  LOCALS
locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
}

locals { 
  name = "${var.app_name}-${local.timestamp}" 
}

#  SOURCE
source "amazon-ebs" "ubuntu" {
  access_key                  = var.access_key
  ami_name                    = local.name
  associate_public_ip_address = true
  instance_type               = var.instance_type
  region                      = var.region
  secret_key                  = var.secret_key
  source_ami                  = var.source_ami
  ssh_username                = var.ssh_username

  #  VPC Configuration - let Packer find default or create temporary
  vpc_filter {
    filters = {
      "is-default" = "true"
    }
  }
  
  # If no default VPC, use any available VPC
  subnet_filter {
    filters = {
      "availability-zone" = "us-east-1a"
    }
    most_free = true
    random = false
  }

  tags = {
    App_Name    = var.app_name
    App_Version = var.app_version
    Name        = local.name
    OS_Version  = "Ubuntu 24.04"
    Environment = "production"
    Project     = "FinTech-Solutions"
    Component   = "apollo-server"
    Monitoring  = "enabled"
  }
}

#  BUILD
build {
  sources = ["source.amazon-ebs.ubuntu"]

  # Crear estructura de directorios
  provisioner "shell" {
    inline = [
      "mkdir -p /home/${var.ssh_username}/app",
      "mkdir -p /home/${var.ssh_username}/beats",
      "mkdir -p /home/${var.ssh_username}/scripts"
    ]
  }
  
  # Copiar aplicación Apollo
  provisioner "file" {
    source      = "./app/index.ts"
    destination = "/home/${var.ssh_username}/app/index.ts"
  }
  
  provisioner "file" {
    source      = "./app/package.json"
    destination = "/home/${var.ssh_username}/app/package.json"
  }
  
  provisioner "file" {
    source      = "./app/tsconfig.json"
    destination = "/home/${var.ssh_username}/app/tsconfig.json"
  }

  # Copiar configuraciones de Beats
  provisioner "file" {
    source      = "./beats/"
    destination = "/home/${var.ssh_username}/"
  }

  # Copiar scripts
  provisioner "file" {
    source      = "./scripts/"
    destination = "/home/${var.ssh_username}/"
  }

  # Ejecutar script de provisión
  provisioner "shell" {
    script = "./scripts/provision.sh"
  }

  # Validación post-instalación
  provisioner "shell" {
    inline = [
      "echo ' Running post-installation validation...'",
      "node --version",
      "npm --version",
      "pm2 --version",
      "nginx -v",
      "systemctl is-enabled nginx",
      "systemctl is-enabled filebeat",
      "systemctl is-enabled metricbeat",
      "echo ' Apollo Server AMI validation completed'"
    ]
  }

  # Generar manifest
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}
