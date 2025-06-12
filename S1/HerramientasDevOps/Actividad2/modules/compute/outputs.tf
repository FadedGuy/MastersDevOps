output "app_instance_id" {
  value = aws_instance.app.id
}

output "app_public_ip" {
  value = aws_instance.app.public_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "mongo_public_ip" {
  value = aws_instance.mongodb.public_ip
}

output "mongo_private_ip" {
  value = aws_instance.mongodb.private_ip
}

