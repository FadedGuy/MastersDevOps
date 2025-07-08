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
    Component   = "elk-stack"
    Monitoring  = "central-hub"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "mkdir -p /home/${var.ssh_username}/scripts",
      "mkdir -p /home/${var.ssh_username}/elasticsearch",
      "mkdir -p /home/${var.ssh_username}/kibana", 
      "mkdir -p /home/${var.ssh_username}/logstash",
      "mkdir -p /home/${var.ssh_username}/apm-server"
    ]
  }

  provisioner "file" {
    source      = "./scripts/"
    destination = "/home/${var.ssh_username}/"
  }

  provisioner "file" {
    source      = "./elasticsearch/"
    destination = "/home/${var.ssh_username}/"
  }

  provisioner "file" {
    source      = "./kibana/"
    destination = "/home/${var.ssh_username}/"
  }

  provisioner "file" {
    source      = "./logstash/"
    destination = "/home/${var.ssh_username}/"
  }

  provisioner "file" {
    source      = "./apm-server/"
    destination = "/home/${var.ssh_username}/"
  }

  provisioner "shell" {
    script = "./scripts/provision.sh"
  }

  provisioner "shell" {
    inline = [
      "echo ' Running ELK Stack validation...'",
      "java -version",
      "systemctl is-enabled elasticsearch",
      "systemctl is-enabled kibana", 
      "systemctl is-enabled logstash",
      "systemctl is-enabled apm-server",
      "systemctl is-enabled nginx",
      "nginx -v",
      "echo ' ELK Stack AMI validation completed'"
    ]
  }

  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}
