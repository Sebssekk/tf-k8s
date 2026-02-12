resource "random_integer" "init_zone_cp" {
  min = 0
  max = 2
}

resource "google_compute_instance" "cps" {
  count = var.cp_num
  
  zone = "${var.gcp_region}-${local.zones[(random_integer.init_zone_cp.result + count.index) % length(local.zones)]}"
  name = "${var.prefix_name}-cp${count.index}"
  machine_type = var.cp_machine_type
  network_interface {
    subnetwork = var.subnet_id
    access_config {
      # Ephimeral Public IP
    }
  }
  boot_disk {
    initialize_params {
      image = var.node_image
      size  = var.node_disk_size
    }
  }

  service_account {
    email = var.cp_sa_email
    scopes = [ "cloud-platform" ]
  }

  metadata = {
    cluster = var.prefix_name
    enable-oslogin = "false"
    ssh-keys = "${var.node_ssh_user}:${local.ssh_public_key_material}"
    enable-guest-attributes: "true",
  }
  # TO check the startup script logs
  # sudo journalctl -efu google-startup-scripts.service
  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -x
    export K8S_ROLE=cp
    ${local.k8s-init}
  EOT
}
