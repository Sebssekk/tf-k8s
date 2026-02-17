module "k8s_network" {
  source = "./modules/network"

  prefix_name = var.prefix_name
  gcp_region = var.gcp_region
  subnet_cidr = "192.168.0.0/24"
}

module "node_iam" {
  source = "./modules/node_iam"
  project_id = var.project_id
  prefix_name = var.prefix_name
}

module "k8s_firewall" {
  source = "./modules/firewall"
  
  prefix_name = var.prefix_name
  vpc_id = module.k8s_network.vpc_id
  cp_sa_email = module.node_iam.cp_sa_email
  wk_sa_email = module.node_iam.wk_sa_email
}

module "k8s_cluster" {
  source = "./modules/k8s-cluster"
  
  prefix_name = var.prefix_name
  project_id = var.project_id
  terraform_running_OS = var.host_os
  gcp_region = var.gcp_region
  wk_num = 2
  subnet_id = module.k8s_network.subnet_id
  cp_sa_email = module.node_iam.cp_sa_email
  wk_sa_email = module.node_iam.wk_sa_email
}

output "cluster_details" {
  value = {
    CP_IPS = module.k8s_cluster.cps_pub_ip
    WK_IPS = module.k8s_cluster.wks_priv_ip
    KUBECONFIG = module.k8s_cluster.kubeconfig
  }
}

resource "local_file" "kubeconfig" {
  content = module.k8s_cluster.kubeconfig
  filename = "${path.root}/${var.prefix_name}-kubeconfig"
}

locals {
  kubeconfig_obj = yamldecode(module.k8s_cluster.kubeconfig)
}

provider "kubernetes" {
  host = local.kubeconfig_obj.clusters[0].cluster.server
  cluster_ca_certificate =  base64decode(local.kubeconfig_obj.clusters[0].cluster.certificate-authority-data)
  client_certificate = base64decode(local.kubeconfig_obj.users[0].user.client-certificate-data)
  client_key = base64decode(local.kubeconfig_obj.users[0].user.client-key-data)
}

data "kubernetes_nodes" "k8s_nodes" {
  depends_on = [ local_file.kubeconfig ]
}

output "k8s_nodes" {
  value = data.kubernetes_nodes.k8s_nodes.nodes[*].metadata[0].name
}