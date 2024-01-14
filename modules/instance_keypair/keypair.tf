resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.name
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "this" {
  content         = tls_private_key.this.private_key_pem
  filename        = "${path.cwd}/${var.name}.pem"
  file_permission = "0600"
}
