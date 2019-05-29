output "master_auth" {
  value = element(google_container_cluster.default.master_auth, 0)
}

output "name" {
  value = google_container_cluster.default.name
}
