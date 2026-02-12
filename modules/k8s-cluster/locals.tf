locals {
  zones = ["a", "b", "c"]

  ssh_public_key_material = var.shared_ssh_keypair ? var.shared_ssh_publickey_material : tls_private_key.ssh_key[0].public_key_openssh
  ssh_private_key_material = var.shared_ssh_keypair ? var.shared_ssh_privatekey_material : tls_private_key.ssh_key[0].private_key_openssh

  k8s-init = templatefile("${path.module}/user-data.sh.tftpl",{
    K8S_VERSION = var.K8S_VERSION
    ETCD_VERSION = var.ETCD_VERSION
    CILIUM_VERSION = var.CILIUM_VERSION
    CLUSTER_READY = var.CLUSTER_READY
    PKEY = local.ssh_private_key_material
    USER = var.node_ssh_user
    POD_NETWORK_CIDR = var.POD_NETWORK_CIDR
  })

  

  kubeconfig = var.terraform_running_OS == "linux" ? data.external.fetcher_linux[0].result.content : data.external.fetcher_windows[0].result.content
}