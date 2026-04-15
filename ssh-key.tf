# SSH Key configuration: Dynamically create SSH key pair

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "private_key" {
  filename = "${path.module}/terraform-key.pem"
  content  = tls_private_key.example.private_key_pem
  file_permission = "0600"
}

# Output the private key file path
output "private_key_path" {
  value       = local_file.private_key.filename
  description = "Path to the private key file"
}

output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
  description = "Private key content (sensitive)"
}