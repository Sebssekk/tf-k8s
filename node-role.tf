resource "google_project_iam_custom_role" "k8s_node_role" {
  role_id = "k8s_node_role"
  title = "K8S Node Role"
  permissions = [ 
    "compute.instances.get",
    "compute.instances.list",
    "compute.instances.getGuestAttributes"
   ]
}

resource "google_project_iam_binding" "k8s_node_role_binding" {
  project = var.project_id
  members =[ for email in flatten([ 
    google_service_account.cp_sa[*].email, google_service_account.wk_sa[*].email
  ]) : "serviceAccount:${email}"]
  role = google_project_iam_custom_role.k8s_node_role.id
}