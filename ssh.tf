resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "local_file" "foo" {
  content  = tls_private_key.ssh_key.private_key_openssh
  filename = "${path.module}/key"
}