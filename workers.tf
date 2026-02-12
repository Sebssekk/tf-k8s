resource "google_service_account" "wk_sa" {
  count = var.cluster_num
  display_name = "Service Account for WORKERS of cluster ${count.index}"
  account_id = "wk${count.index}-sa"
}

locals {
  wk_vms = flatten([ for c in range(var.cluster_num) : [ for vm in range(var.worker_num) : {cluster : c, index:vm} ]])
}

resource "google_compute_instance" "worker" {
  #depends_on = [module.cp_waiter]
  for_each = { for idx,vm in local.wk_vms : idx => vm }
  
  zone = "${var.regions[each.value.cluster % length(var.regions)]}-${local.zones[each.key % length(local.zones)]}"
  name = "wk${each.value.index}-cluster${each.value.cluster}"
  machine_type = "e2-medium"
  network_interface {
    subnetwork = google_compute_subnetwork.k8s_subnets[each.value.cluster].id
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size  = 20
    }
  }

  service_account {
    email = google_service_account.cp_sa[each.value.cluster].email
    scopes = [ "cloud-platform" ]
  }

  metadata = {
    cluster = "cluster${each.value.cluster}"
    enable-oslogin = "false"
    ssh-keys = "${var.node_ssh_user}:${tls_private_key.ssh_key.public_key_openssh}"
    enable-guest-attributes = "true",
    cp = google_compute_instance.cp[each.value.cluster * var.cp_num].name
  }
  # TO check the startup script logs
  # sudo journalctl -u google-startup-scripts.service
  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -x
    export K8S_ROLE=wk
    ${local.k8s-init}
  EOT
}
