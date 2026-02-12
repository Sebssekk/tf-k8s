# modules/waiter

Purpose
- Wait for a GCE instance guest-attribute to reach a specific value (used to detect when startup scripts finished).

Key inputs (see [modules/waiter/variables.tf](modules/waiter/variables.tf))
- [`var.project_id`](modules/waiter/variables.tf)
- [`var.terraform_running_OS`](modules/waiter/variables.tf)
- [`var.zone`](modules/waiter/variables.tf)
- [`var.instance_name`](modules/waiter/variables.tf)
- [`var.instance_id`](modules/waiter/variables.tf)
- [`var.attribute_namespace`](modules/waiter/variables.tf]
- [`var.attribute_key`](modules/waiter/variables.tf)
- [`var.expected_value`](modules/waiter/variables.tf)
- [`var.timeout_seconds`](modules/waiter/variables.tf)

Implementation
- Uses `google_client_config` data source: [modules/waiter/google-client-config.tf](modules/waiter/google-client-config.tf)
- Linux implementation: [modules/waiter/main-linux.tf](modules/waiter/main-linux.tf)
- Windows implementation: [modules/waiter/main-windows.tf](modules/waiter/main-windows.tf)

Usage
- This module is invoked by [modules/k8s-cluster/wait-k8s-setup.tf](modules/k8s-cluster/wait-k8s-setup.tf) for both control-plane and worker VMs.
``````markdown
// filepath: c:\Users\sebss\Desktop\k8s-tf\modules\waiter\README.md
# modules/waiter

Purpose
- Wait for a GCE instance guest-attribute to reach a specific value (used to detect when startup scripts finished).

Key inputs (see [modules/waiter/variables.tf](modules/waiter/variables.tf))
- [`var.project_id`](modules/waiter/variables.tf)
- [`var.terraform_running_OS`](modules/waiter/variables.tf)
- [`var.zone`](modules/waiter/variables.tf)
- [`var.instance_name`](modules/waiter/variables.tf)
- [`var.instance_id`](modules/waiter/variables.tf)
- [`var.attribute_namespace`](modules/waiter/variables.tf]
- [`var.attribute_key`](modules/waiter/variables.tf)
- [`var.expected_value`](modules/waiter/variables.tf)
- [`var.timeout_seconds`](modules/waiter/variables.tf)

Implementation
- Uses `google_client_config` data source: [modules/waiter/google-client-config.tf](modules/waiter/google-client-config.tf)
- Linux implementation: [modules/waiter/main-linux.tf](modules/waiter/main-linux.tf)
- Windows implementation: [modules/waiter/main-windows.tf](modules/waiter/main-windows.tf)

Usage
- This module is invoked by [modules/k8s-cluster/wait-k8s-setup.tf](modules/k8s-cluster/wait-k8s-setup.tf) for both control-plane and worker VMs.