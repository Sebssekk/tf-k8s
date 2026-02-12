data "external" "fetcher_linux" {
  count = var.host_os == "linux" ? var.cluster_num : 0

  program = ["bash", "${path.module}/read_remote.sh"]

  query = {
    host = google_compute_instance.cp[count.index * var.cp_num].network_interface.0.access_config.0.nat_ip
    user = var.node_ssh_user
    key  = tls_private_key.ssh_key.private_key_openssh
    file = "/home/${var.node_ssh_user}/.kube/config" # The file you want to read
  }

  # Wait for the VM to be ready
  depends_on = [ module.cp_waiter ]
}

data "external" "fetcher_windows" {
  count = var.host_os == "windows" ? var.cluster_num : 0

  program = ["PowerShell", "-File", "${path.module}/read_remote.ps1"]

  query = {
    host = google_compute_instance.cp[count.index * var.cp_num].network_interface.0.access_config.0.nat_ip
    user = var.node_ssh_user
    key  = tls_private_key.ssh_key.private_key_openssh
    file = "/home/${var.node_ssh_user}/.kube/config"
  }

  depends_on = [ module.cp_waiter ]
}

locals {
  kubeconfig = var.host_os == "linux" ? data.external.fetcher_linux[*].result.content : data.external.fetcher_windows[*].result.content
}

output "clusters_details" {
  value = { for c in range(var.cluster_num) : 
    "CLUSTER${c}" => {
      CP_PUB_IPS = [ for cp in slice(values(google_compute_instance.cp), c * var.cp_num, (c * var.cp_num) + var.cp_num ) : cp.network_interface[0].access_config[0].nat_ip ]
      CP_IPS = [ for cp in slice(values(google_compute_instance.cp), c * var.cp_num, (c * var.cp_num) + var.cp_num ) : cp.network_interface[0].network_ip ]
      WK_IPS = [ for wk in slice(values(google_compute_instance.worker), c * var.worker_num, (c * var.worker_num) + var.worker_num ) : wk.network_interface[0].network_ip ]
      #KUBECONFIG = var.host_os == "linux" ? data.external.fetcher_linux[c].result.content : data.external.fetcher_windows[c].result.content
      KUBECONFIG = replace(local.kubeconfig[c],"/(server:\\s+https://)[0-9.]+/", "$${1}${google_compute_instance.cp[c * var.cp_num].network_interface[0].access_config[0].nat_ip}") 
    }
  }
}