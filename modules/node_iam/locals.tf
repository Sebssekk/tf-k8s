locals {
  cp_sa_email =  var.shared_sa_cp ? var.shared_sa_cp_email : google_service_account.cp_sa[0].email
  wk_sa_email =  var.shared_sa_wk ? var.shared_sa_wk_email : google_service_account.wk_sa[0].email
  node_role = var.shared_node_role ? var.shared_node_role_id : google_project_iam_custom_role.k8s_node_role[0].id
}