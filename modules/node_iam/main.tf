resource "google_service_account" "wk_sa" {
  count = var.shared_sa_wk ? 0 : 1
  display_name = "${var.prefix_name} Service Account for WKs"
  account_id = "wk-cluster${count.index}-sa"
}

resource "google_service_account" "cp_sa" {
  count = var.shared_sa_cp ? 0 : 1
  display_name = "${var.prefix_name} Service Account for CPs"
  account_id = "cp-cluster${count.index}-sa"
}


resource "google_project_iam_custom_role" "k8s_node_role" {
  count = var.shared_node_role ? 0 : 1
  role_id = "${var.prefix_name}_node_role"
  title = "${var.prefix_name} Node Role"
  permissions = [ 
    "compute.instances.get",
    "compute.instances.list",
    "compute.instances.getGuestAttributes"
   ]
}

resource "google_project_iam_binding" "k8s_node_role_binding" {
  project = var.project_id
  members =[ for email in [local.cp_sa_email, local.wk_sa_email] : "serviceAccount:${email}"]
  role = local.node_role
}

