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

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ansible"
    ]
  }

  provisioner "ansible-local" {
    playbook_dir  = "../ansible/"
    playbook_file = "../ansible/playbook.yml"
  }

  post-processor "manifest" {
    output = "manifest.json"
  }

  post-processor "shell-local" {
    inline = [
      "powershell -Command \"$m=Get-Content manifest.json | ConvertFrom-Json; $ami=$m.builds[-1].artifact_id.Split(':')[1]; aws ec2 run-instances --region ${var.region} --image-id $ami --instance-type ${var.instance_type} --key-name ${var.key_pair} --associate-public-ip-address --security-group-ids ${var.security_group}\""
    ]
  }
}