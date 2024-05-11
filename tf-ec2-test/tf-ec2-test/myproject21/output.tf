
# output.tf
output "instance1_private_ip" {
  value = aws_instance.example1.private_ip
}

output "instance_id" {
  value = aws_instance.example1.id
}