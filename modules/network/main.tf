resource "google_compute_network" "k8s_vpc" {
    count = var.shared_vpc ? 0 : 1
    name = "${var.prefix_name}-vpc"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "k8s_subnets" {
  count = var.shared_subnet ? 0 : 1
  network = local.vpc_id
  region = var.gcp_region
  name = "${var.prefix_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  private_ip_google_access = true
}

resource "google_compute_router" "k8s_vpc_router" {
  count = var.create_router_nat ? 1 : 0
  name = "${var.prefix_name}-vpc-router"
  region = var.gcp_region
  network = local.vpc_id
}

resource "google_compute_router_nat" "k8s_vpc_nat" {
  count = var.create_router_nat ? 1 : 0
  name = "${var.prefix_name}-vpc-router-nat"
  router = google_compute_router.k8s_vpc_router[0].name
  region = var.gcp_region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option = "AUTO_ONLY"
}

