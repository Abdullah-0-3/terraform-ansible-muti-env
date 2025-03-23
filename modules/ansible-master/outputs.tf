output "instance_id" {
  description = "ID of the Ansible master instance"
  value       = aws_instance.ansible_master.id
}

output "public_ip" {
  description = "Public IP of the Ansible master instance"
  value       = aws_instance.ansible_master.public_ip
}

output "private_ip" {
  description = "Private IP of the Ansible master instance"
  value       = aws_instance.ansible_master.private_ip
}
