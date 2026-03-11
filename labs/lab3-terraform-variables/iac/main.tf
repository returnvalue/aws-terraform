variable "instance_type" {
  description = "The size of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
}

output "web_server_id" {
  description = "The ID of the provisioned EC2 instance"
  value       = aws_instance.web_server.id
}
