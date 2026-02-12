locals {
  k8s-init = templatefile("${path.module}/user-data.sh.tftpl",{
    K8S_VERSION = var.K8S_VERSION
    ETCD_VERSION = var.ETCD_VERSION
    CILIUM_VERSION = var.CILIUM_VERSION
    CLUSTER_READY = var.CLUSTER_READY
    PKEY = tls_private_key.ssh_key.private_key_openssh
    USER = var.node_ssh_user
    POD_NETWORK_CIDR = var.POD_NETWORK_CIDR
  })
}