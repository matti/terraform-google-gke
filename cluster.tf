resource "random_uuid" "google_container_cluster" {
  count = var.name == null ? 1 : 0
}


resource "google_container_cluster" "default" {
  name     = var.name == null ? random_uuid.google_container_cluster.result : var.name
  location = var.location

  min_master_version = var.minimum_version

  initial_node_count       = 1
  remove_default_node_pool = true

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network = var.network

  dynamic "private_cluster_config" {
    for_each = var.private_nodes == true ? list(var.master_ipv4_cidr_block) : []

    content {
      enable_private_nodes   = true
      master_ipv4_cidr_block = private_cluster_config.value
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "all"
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  ip_allocation_policy {
    create_subnetwork = true
    // Prior to June 17th 2019, the default on the API is false; afterwards, it's true.
    use_ip_aliases = true
  }

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }
  }

  # beta:
  #monitoring_service = "monitoring.googleapis.com/kubernetes"
}
