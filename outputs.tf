output "web_server_id" {
  description = "The ID of the provisioned EC2 instance"
  value       = aws_instance.web_server.id
}
