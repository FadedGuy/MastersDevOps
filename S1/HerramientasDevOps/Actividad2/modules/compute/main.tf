data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:App_Name"
    values = [var.app_ami_name_tag]
  }
}

data "aws_ami" "mongodb_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:App_Name"
    values = [var.mongo_ami_name_tag]
  }
}

resource "aws_instance" "mongodb" {
  ami                    = data.aws_ami.mongodb_ami.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.mongodb_sg_id]
  key_name               = var.key_name

  tags = {
    Name = "MongoDB-Instance"
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.app_sg_id]
  key_name               = var.key_name

  tags = {
    Name = "App-Instance"
  }
}
