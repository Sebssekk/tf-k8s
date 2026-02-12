resource "tls_private_key" "ssh_key" {
  count = var.shared_ssh_keypair ? 0 : 1
  algorithm = "ED25519"
}

resource "local_file" "foo" {
  count = var.shared_ssh_keypair ? 0 : 1
  content  = local.ssh_private_key_material
  filename = "${path.root}/key"
}