resource "google_container_node_pool" "default" {
  count    = length(var.node_pools)
  provider = "google-beta"

  lifecycle {
    create_before_destroy = true
  }

  cluster  = google_container_cluster.default.name
  location = google_container_cluster.default.location

  node_count = lookup(var.node_pools[count.index], "node_count", -1) == -1 ? null : lookup(var.node_pools[count.index], "node_count")

  dynamic "autoscaling" {
    for_each = lookup(var.node_pools[count.index], "node_count", -1) == -1 ? [1] : []
    content {
      min_node_count = lookup(var.node_pools[count.index], "autoscaling_minimum", 0)
      max_node_count = lookup(var.node_pools[count.index], "autoscaling_maximum", 333)
    }
  }

  node_config {
    machine_type = lookup(var.node_pools[count.index], "machine_type")
    disk_size_gb = lookup(var.node_pools[count.index], "disk_size_gb")
    disk_type    = lookup(var.node_pools[count.index], "disk_type")

    oauth_scopes = var.oauth_scopes

    workload_metadata_config {
      node_metadata = "SECURE"
    }

    preemptible = lookup(var.node_pools[count.index], "preemptible", false)

    labels = lookup(var.node_pools[count.index], "labels", {})

    dynamic "taint" {
      for_each = lookup(var.node_pools[count.index], "taints", [])
      content {
        key    = taint["value"]["key"]
        value  = taint["value"]["value"]
        effect = taint["value"]["effect"]
      }
    }
  }

  management {
    auto_upgrade = false
    auto_repair  = false
  }
}
