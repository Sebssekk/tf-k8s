output "cps_pub_ip" {
  value = google_compute_instance.cps[*].network_interface[0].access_config[0].nat_ip
}

output "cps_priv_ip" {
  value = google_compute_instance.cps[*].network_interface[0].network_ip
}

output "wks_priv_ip" {
  value = google_compute_instance.wks[*].network_interface[0].network_ip
}

output "kubeconfig" {
  value = replace(local.kubeconfig,"/(server:\\s+https://)[0-9.]+/", "$${1}${google_compute_instance.cps[0].network_interface[0].access_config[0].nat_ip}") 
}