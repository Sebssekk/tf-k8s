# modules/firewall

Purpose
- Create firewall rules necessary for cluster connectivity (SSH, API server and intra-cluster comms).

Key inputs (see [modules/firewall/variables.tf](modules/firewall/variables.tf))
- [`var.prefix_name`](modules/firewall/variables.tf)
- [`var.vpc_id`](modules/firewall/variables.tf)
- [`var.cp_sa_email`](modules/firewall/variables.tf)
- [`var.wk_sa_email`](modules/firewall/variables.tf)

Main resources
- Firewall rules defined in [modules/firewall/main.tf](modules/firewall/main.tf)