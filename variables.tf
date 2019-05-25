variable "name" {
  default = null
}

variable "location" {

}

variable "minimum_version" {
  default = "1.13"
}

variable "network" {

}

variable "private_nodes" {
  default = false
}

variable "master_ipv4_cidr_block" {
  default = "172.16.0.0/28"
}

variable "node_pools" {
  default = [
    {
      machine_type = "n1-standard-1"
      disk_size_gb = 10
      disk_type    = "pd-ssd"
      preemptible  = true
      labels = {
        type = "e"
      }
      taints = [
        {
          key    = "scaleToZero"
          value  = "yes"
          effect = "NO_EXECUTE"
        }
      ]
    },
    {
      machine_type = "n1-standard-1"
      disk_size_gb = 10
      disk_type    = "pd-ssd"
      preemptible  = true #TODO
    }
  ]
}

variable "oauth_scopes" {
  default = [
    "storage-ro",
    "logging-write", # if stackdriver
    "monitoring",    # if google monitoring
  ]
}
