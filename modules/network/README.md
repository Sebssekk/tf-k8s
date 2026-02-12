# modules/network

Purpose
- Create (or reference) a VPC and subnet and optional Cloud Router/NAT for the cluster.

Key inputs (see [modules/network/variable.tf](http://_vscodecontentref_/0))
- [var.prefix_name](http://_vscodecontentref_/1)
- [var.shared_vpc](http://_vscodecontentref_/2) and [var.shared_vpc_id](http://_vscodecontentref_/3)
- [var.shared_subnet](http://_vscodecontentref_/4) and [var.shared_subnet_id](http://_vscodecontentref_/5)
- [var.gcp_region](http://_vscodecontentref_/6)
- [var.subnet_cidr](http://_vscodecontentref_/7)
- [var.create_router_nat](http://_vscodecontentref_/8)

Outputs (see [modules/network/output.tf](http://_vscodecontentref_/9))
- [output "vpc_id"](http://_vscodecontentref_/10)
- [output "subnet_id"](http://_vscodecontentref_/11)

Main resources
- Network/subnet: [modules/network/main.tf](http://_vscodecontentref_/12)