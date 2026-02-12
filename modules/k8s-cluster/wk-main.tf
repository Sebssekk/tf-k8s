resource "random_integer" "init_zone_wk" {
  min = 0
  max = 2
}

resource "google_compute_instance" "wks" {
  count = var.wk_num
  
  zone = "${var.gcp_region}-${local.zones[(random_integer.init_zone_wk.result + count.index) % length(local.zones)]}"
  name = "${var.prefix_name}-wk${count.index}"
  machine_type = var.wk_machine_type
  network_interface {
    subnetwork = var.subnet_id
  }
  boot_disk {
    initialize_params {
      image = var.node_image
      size  = var.node_disk_size
    }
  }

  service_account {
    email = var.wk_sa_email
    scopes = [ "cloud-platform" ]
  }

  metadata = {
    cp = google_compute_instance.cps[0].name
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
    export K8S_ROLE=wk
    ${local.k8s-init}
  EOT
}
