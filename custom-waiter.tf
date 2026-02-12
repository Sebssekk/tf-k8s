module "cp_waiter" {
  depends_on = [ google_compute_instance.cp ]
  for_each = google_compute_instance.cp
  source = "./waiter"

  host_os = var.host_os
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
  depends_on = [ google_compute_instance.worker ]
  for_each = google_compute_instance.worker
  source = "./waiter"

  host_os = var.host_os
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