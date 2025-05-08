packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

locals {
  name = "webApp-${local.timestamp}"
}

source "amazon-ebs" "ubuntu" {
  access_key                  = var.aws_access_key
  ami_name                    = local.name
  associate_public_ip_address = true
  instance_type               = var.aws_instance_type
  region                      = var.aws_region
  secret_key                  = var.aws_secret_key
  source_ami                  = var.aws_source_ami
  ssh_username                = var.aws_ssh_username
  tags = {
    App_Version = var.app_version
    Name        = local.name
    OS_Version  = "Ubuntu 24.04"
  }
}

source "azure-arm" "ubuntu" {
  client_id = var.azure_client_id
  client_secret = var.azure_client_secret
  subscription_id = var.azure_subscription_id
  tenant_id = var.azure_tenant_id

  image_publisher   = var.azure_image_publisher
  image_offer       = var.azure_image_offer
  image_sku         = var.azure_image_sku
  location = var.azure_location

  managed_image_name     = local.name
  managed_image_resource_group_name = var.azure_resource_group
  ssh_username = var.azure_ssh_username
  os_type           = "Linux"
  vm_size           = var.azure_vm_size
  azure_tags = {
    App_Version = var.app_version
    Name = local.name
    OS_Version = var.azure_image_offer
  }
}

build {
  sources = ["source.azure-arm.ubuntu"]

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
      "powershell -Command \"$m=Get-Content manifest.json | ConvertFrom-Json; $artifact=$m.builds[-1].artifact_id; $imageName=$artifact.Split('/')[-1]; az vm create --resource-group ${var.azure_resource_group} --name ${local.name} --image $imageName --admin-username ${var.azure_ssh_username} --generate-ssh-keys --size Standard_B1s --location ${var.azure_location} --nsg-rule 'SSH'; az vm open-port --port 80 --resource-group ${var.azure_resource_group} --name ${local.name}\""
    ]
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
