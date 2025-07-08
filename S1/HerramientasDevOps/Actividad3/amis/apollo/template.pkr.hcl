packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
}

locals { 
  name = "${var.app_name}-${local.timestamp}" 
}

source "amazon-ebs" "ubuntu" {
  access_key                  = var.access_key
  ami_name                    = local.name
  associate_public_ip_address = true
  instance_type               = var.instance_type
  region                      = var.region
  secret_key                  = var.secret_key
  source_ami                  = var.source_ami
  ssh_username                = var.ssh_username

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

build {
  sources = ["source.amazon-ebs.ubuntu"]

  #  Crear estructura de directorios
  provisioner "shell" {
    inline = [
      "mkdir -p /home/${var.ssh_username}/app",
      "mkdir -p /home/${var.ssh_username}/beats",
      "mkdir -p /home/${var.ssh_username}/scripts"
    ]
  }
  
  #  Copiar aplicación Apollo
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

  #  Copiar configuraciones de Beats
  provisioner "file" {
    source      = "./beats/"
    destination = "/home/${var.ssh_username}/"
  }

  #  Copiar scripts
  provisioner "file" {
    source      = "./scripts/"
    destination = "/home/${var.ssh_username}/"
  }

  #  Ejecutar script de provisión
  provisioner "shell" {
    script = "./scripts/provision.sh"
  }

  #  Validación post-instalación
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

  #  Generar manifest
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}
