packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }
locals { name = "${var.app_name}-${local.timestamp}" }

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
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "file" {
    source      = "./app"
    destination = "/home/${var.ssh_username}/app"
  }

  provisioner "file" {
    source      = "./scripts"
    destination = "/home/${var.ssh_username}/scripts"
  }

  provisioner "shell" {
    script = "./scripts/provision.sh"
  }

  post-processor "manifest" {
    output = "manifest.json"
  }
}