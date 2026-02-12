data "external" "fetcher_linux" {
  count = var.terraform_running_OS == "linux" ? 1 : 0

  program = ["bash", "${path.module}/read_remote.sh"]

  query = {
    host = google_compute_instance.cps[0].network_interface[0].access_config[0].nat_ip
    user = var.node_ssh_user
    key  = local.ssh_private_key_material
    file = "/home/${var.node_ssh_user}/.kube/config" # The file you want to read
  }

  # Wait for the VM to be ready
  depends_on = [ module.cp_waiter ]
}

data "external" "fetcher_windows" {
  count = var.terraform_running_OS == "windows" ? 1 : 0

  program = ["PowerShell", "-File", "${path.module}/read_remote.ps1"]

  query = {
    host = google_compute_instance.cps[0].network_interface[0].access_config[0].nat_ip
    user = var.node_ssh_user
    key  = local.ssh_private_key_material
    file = "/home/${var.node_ssh_user}/.kube/config" # The file you want to read
  }

  depends_on = [ module.cp_waiter ]
}