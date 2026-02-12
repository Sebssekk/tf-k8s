# modules/node_iam

Purpose
- Create service accounts and a custom role for cluster nodes (unless provided externally).

Key inputs (see [modules/node_iam/variables.tf](modules/node_iam/variables.tf))
- [`var.prefix_name`](modules/node_iam/variables.tf)
- [`var.project_id`](modules/node_iam/variables.tf)
- Shared SA toggles: [`var.shared_sa_cp`](modules/node_iam/variables.tf), [`var.shared_sa_cp_email`](modules/node_iam/variables.tf), [`var.shared_sa_wk`](modules/node_iam/variables.tf), [`var.shared_sa_wk_email`](modules/node_iam/variables.tf)
- Shared role toggles: [`var.shared_node_role`](modules/node_iam/variables.tf), [`var.shared_node_role_id`](modules/node_iam/variables.tf)

Outputs (see [modules/node_iam/outputs.tf](modules/node_iam/outputs.tf))
- [`output "cp_sa_email"`](modules/node_iam/outputs.tf)
- [`output "wk_sa_email"`](modules/node_iam/outputs.tf)
- [`output "role_id"`](modules/node_iam/outputs.tf)

Main resources
- Service accounts, custom role, and binding: [modules/node_iam/main.tf](modules/node_iam/main.tf)
- Local logic for selection: [modules/node_iam/locals.tf](modules/node_iam/locals.tf)