# k8s-tf

Small Terraform project that provisions a GCP VPC, service accounts/roles, firewall rules and a set of GCE VMs that bootstrap a Kubernetes cluster and expose a generated kubeconfig.

Important files
- Terraform root: [main.tf](main.tf)
- Root variables: [`var.project_id`](variables.tf), [`var.gcp_region`](variables.tf), [`var.host_os`](variables.tf) — see [variables.tf](variables.tf)
- Credentials helpers: [env-auth.bash](env-auth.bash) and [env-auth.ps1](env-auth.ps1); service account file: [sa-key.json](sa-key.json)
- Module list: [modules/network](modules/network), [modules/node_iam](modules/node_iam), [modules/firewall](modules/firewall), [modules/k8s-cluster](modules/k8s-cluster), [modules/waiter](modules/waiter)

Quickstart
1. Put your service account JSON at [sa-key.json](sa-key.json) and export credentials:
   - Linux/macOS: source [env-auth.bash](env-auth.bash)
   - Windows PowerShell: run [env-auth.ps1](env-auth.ps1)
2. Populate variables in [terraform.tfvars](terraform.tfvars) (example values present). Key variables:
   - [`var.project_id`](variables.tf) — GCP project id
   - [`var.gcp_region`](variables.tf) — GCP region
   - [`var.host_os`](variables.tf) — "linux" or "windows"
3. Initialize and apply:
```sh
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

4. After successful apply:
- kubeconfig is written to root as `${var.prefix_name}-kubeconfig` via the resource in [main.tf](main.tf) (`local_file.kubeconfig`)
- main outputs are in [main.tf](main.tf) (`output "cluster_details"`)

Notes & behavior
- The cluster VM bootstrap is defined in [modules/k8s-cluster/user-data.sh.tftpl](modules/k8s-cluster/user-data.sh.tftpl).
- Kubeconfig fetching is implemented by [modules/k8s-cluster/kubeconfig-fetcher.tf](modules/k8s-cluster/kubeconfig-fetcher.tf) which calls [modules/k8s-cluster/read_remote.sh](modules/k8s-cluster/read_remote.sh) or [modules/k8s-cluster/read_remote.ps1](modules/k8s-cluster/read_remote.ps1) depending on [`var.terraform_running_OS`](modules/k8s-cluster/variables.tf).
- The waiter that waits for guest-attributes is in [modules/waiter](modules/waiter) (`main-linux.tf`, `main-windows.tf`). See [`variable "timeout_seconds"`](modules/waiter/variables.tf).

If you need to change module inputs, inspect the modules' `variables.tf` files under [modules/*](modules).
