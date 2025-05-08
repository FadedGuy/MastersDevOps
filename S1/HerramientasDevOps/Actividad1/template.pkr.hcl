packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

locals {
  ami_name = "webApp-${local.timestamp}"
}

source "amazon-ebs" "ubuntu" {
  access_key                  = "${var.aws_access_key}"
  ami_name                    = "${local.ami_name}"
  associate_public_ip_address = true
  instance_type               = "${var.aws_instance_type}"
  region                      = "${var.aws_region}"
  secret_key                  = "${var.aws_secret_key}"
  source_ami                  = "${var.aws_source_ami}"
  ssh_username                = "${var.aws_ssh_username}"
  tags = {
    App_Version = "${var.app_version}"
    Name        = "${local.ami_name}"
    OS_Version  = "Ubuntu 24.04"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "file" {
    source      = "./app"
    destination = "/home/${var.aws_ssh_username}/app"
  }

  provisioner "file" {
    source      = "./scripts"
    destination = "/home/${var.aws_ssh_username}/scripts"
  }

  provisioner "shell" {
    script = "./scripts/provision.sh"
  }

  post-processor "manifest" {
    output = "manifest.json"
  }

  post-processor "shell-local" {
    inline = [
      "powershell -Command \"$m=Get-Content manifest.json | ConvertFrom-Json; $ami=$m.builds[-1].artifact_id.Split(':')[1]; aws ec2 run-instances --region ${var.aws_region} --image-id $ami --instance-type ${var.aws_instance_type} --key-name PackerKeyPair --associate-public-ip-address --security-group-ids ${var.aws_security_group}\""
    ]
  }

}
