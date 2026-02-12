resource "google_compute_firewall" "ssh_in" {
  name = "general-ssh-in"
  network = google_compute_network.k8s_vpc.id

  allow {
    protocol = "tcp"
    ports = [22]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_api_server" {
  name = "allow-api-server-call"
  network = google_compute_network.k8s_vpc.id
  allow {
    protocol = "tcp"
    ports = [6443]
  }
  source_ranges = ["0.0.0.0/0"]
  target_service_accounts = google_service_account.cp_sa[*].email
}

resource "google_compute_firewall" "inter_cluster_networking" {
  count = var.cluster_num

  network = google_compute_network.k8s_vpc.id
  source_service_accounts = [
    google_service_account.cp_sa[count.index].email, google_service_account.wk_sa[count.index].email 
  ]
  target_service_accounts = [
    google_service_account.cp_sa[count.index].email, google_service_account.wk_sa[count.index].email 
  ]
  name = "cluster${count.index}-internal"
  
  dynamic "allow" {
    for_each = [ "tcp", "udp", "icmp" ]
    content {
      protocol = allow.value
    } 
  }
}