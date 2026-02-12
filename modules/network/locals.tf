locals {
  vpc_id = var.shared_vpc ? var.shared_vpc_id : google_compute_network.k8s_vpc[0].id
  subnet_id = var.shared_subnet ? var.shared_subnet_id : google_compute_subnetwork.k8s_subnets[0].id
}