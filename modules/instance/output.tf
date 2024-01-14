output "instance_ip" {
  description = "IP of instance created in vpc"
  value       = aws_instance.instance.private_ip
}
output "instance_id" {
  description = "ID of instance created in vpc"
  value       = aws_instance.instance.id
}
