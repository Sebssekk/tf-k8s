# modules/k8s-cluster

Purpose
- Provision control-plane (CP) and worker (WK) GCE instances, bootstrap Kubernetes via startup scripts, fetch kubeconfig and expose it as an output.

Key inputs (see [modules/k8s-cluster/variables.tf](http://_vscodecontentref_/13))
- [var.project_id](http://_vscodecontentref_/14)
- [var.terraform_running_OS](http://_vscodecontentref_/15) (controls linux vs windows helpers)
- Node counts and sizes: [var.cp_num](http://_vscodecontentref_/16), [var.wk_num](http://_vscodecontentref_/17), [var.cp_machine_type](http://_vscodecontentref_/18), [var.wk_machine_type](http://_vscodecontentref_/19)
- SSH key handling: [var.shared_ssh_keypair](http://_vscodecontentref_/20), [var.shared_ssh_privatekey_material](http://_vscodecontentref_/21), [var.shared_ssh_publickey_material](http://_vscodecontentref_/22)
- Other cluster settings (K8S/ETCD/Cilium versions, POD network): see [modules/k8s-cluster/variables.tf](http://_vscodecontentref_/23)

Notable files
- CP instance resources: [modules/k8s-cluster/cp-main.tf](http://_vscodecontentref_/24)
- WK instance resources: [modules/k8s-cluster/wk-main.tf](http://_vscodecontentref_/25)
- Startup/template: [modules/k8s-cluster/user-data.sh.tftpl](http://_vscodecontentref_/26)
- SSH key generation and local file: [modules/k8s-cluster/ssh-key.tf](http://_vscodecontentref_/27) and locals in [modules/k8s-cluster/locals.tf](http://_vscodecontentref_/28)
- Waiter modules usage: [modules/k8s-cluster/wait-k8s-setup.tf](http://_vscodecontentref_/29) (calls the [modules/waiter](http://_vscodecontentref_/30) module)
- Kubeconfig fetch: [modules/k8s-cluster/kubeconfig-fetcher.tf](http://_vscodecontentref_/31) which uses [modules/k8s-cluster/read_remote.sh](http://_vscodecontentref_/32) and [modules/k8s-cluster/read_remote.ps1](http://_vscodecontentref_/33)

Outputs
- Cluster IPs and kubeconfig: see [modules/k8s-cluster/outputs.tf](http://_vscodecontentref_/34) (`output "kubeconfig"`)

Behavior
- The module waits for guest-attributes set by the startup script before attempting to fetch the kubeconfig. That waiter is the [modules/waiter](http://_vscodecontentref_/35) module.