module "cp_waiter" {
  depends_on = [ google_compute_instance.cps ]
  for_each = { for idx,cp in  google_compute_instance.cps : idx => cp}
  source = "../waiter"

  terraform_running_OS = var.terraform_running_OS
  project_id = var.project_id
  zone = each.value.zone
  instance_name = each.value.name
  instance_id   = each.value.id 

  # Customize what we are looking for
  attribute_namespace = "status"
  attribute_key       = "startup"
  expected_value      = "completed"
  timeout_seconds     = 3600
}

module "wk_waiter" {
  depends_on = [ google_compute_instance.wks ]
  for_each = { for idx, wk in google_compute_instance.wks : idx => wk }
  source = "../waiter"

  terraform_running_OS = var.terraform_running_OS
  project_id = var.project_id
  zone = each.value.zone
  instance_name = each.value.name
  instance_id   = each.value.id 

  # Customize what we are looking for
  attribute_namespace = "status"
  attribute_key       = "startup"
  expected_value      = "completed"
  timeout_seconds     = 3600
}