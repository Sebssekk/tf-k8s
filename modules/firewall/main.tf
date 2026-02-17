resource "google_compute_firewall" "public_ssh_in" {
  name = "${var.prefix_name}-public-ssh-in"
  network = var.vpc_id

  allow {
    protocol = "tcp"
    ports = [22]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
  target_service_accounts = [var.cp_sa_email, var.wk_sa_email]
}

resource "google_compute_firewall" "public_api_server_in" {
  name = "${var.prefix_name}-public-api-server-in"
  network =var.vpc_id
  allow {
    protocol = "tcp"
    ports = [6443]
  }
  source_ranges = ["0.0.0.0/0"]
  target_service_accounts = [var.cp_sa_email]
}

resource "google_compute_firewall" "inter_cluster_networking" {
  network = var.vpc_id
  source_service_accounts = [var.cp_sa_email, var.wk_sa_email]
  target_service_accounts = [var.cp_sa_email, var.wk_sa_email]
  name = "${var.prefix_name}-cluster-internal"
  
  allow {
    protocol = "all"
  }
}