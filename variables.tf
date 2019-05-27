variable "network" {

}
variable "location" {

}

variable "name" {
  default = null
}

variable "minimum_version" {
  default = "1.13"
}

variable "private_nodes" {
  default = false
}

variable "master_ipv4_cidr_block" {
  default = "172.16.0.0/28"
}

variable "node_pools" {
  default = []
}

variable "oauth_scopes" {
  default = [
    "storage-ro",
    "logging-write", # if stackdriver
    "monitoring",    # if google monitoring
  ]
}
