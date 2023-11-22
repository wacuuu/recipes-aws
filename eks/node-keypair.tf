resource "tls_private_key" "node_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "node_keypair" {
  key_name   = "node-keypair"
  public_key = tls_private_key.node_keypair.public_key_openssh
}

resource "local_file" "node_keypair" {
  content         = tls_private_key.node_keypair.private_key_pem
  filename        = "node-keypair.pem"
  file_permission = "0600"
}
