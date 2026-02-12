locals {
  cluster_cidr_mask = tonumber(split("/",var.cluster_node_cidr)[1])
}


resource "google_compute_network" "k8s_vpc" {
    name = "k8s-vpc"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "k8s_subnets" {
  count = max(var.cluster_num, length(var.regions))
  network = google_compute_network.k8s_vpc.id
  region = var.regions[count.index % length(var.regions)]
  name = "subnet${count.index}"
  ip_cidr_range = cidrsubnet(var.cluster_node_cidr, var.cluster_node_subnet_mask - local.cluster_cidr_mask, count.index)
  private_ip_google_access = true
}

resource "google_compute_router" "k8s_vpc_router" {
  for_each = {for idx,r in var.regions: idx => r}
  name = "k8s-vpc-router-${each.key}"
  region = each.value
  network = google_compute_network.k8s_vpc.id
}

resource "google_compute_router_nat" "k8s_vpc_nat" {
  for_each = {for idx,r in var.regions: idx => r}
  name = "k8s-vpc-nat-${each.key}"
  router = google_compute_router.k8s_vpc_router[each.key].name
  region = each.value
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option = "AUTO_ONLY"
}

