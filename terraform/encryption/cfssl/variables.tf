variable "etcd_count" {}
variable "master_count" {}
variable "node_count" {}

variable "proxy_count" {}

variable "bastion_host" {}
variable "domain" {}
variable "cluster_public_dns" {}

variable "ssh_user" {
  default = "root"
}

variable "ssh_private_key" {
  default = "~/.ssh/id_rsa.insecure"
}

variable "master_cluster_ip" {
  description = "Kubernetes cluster IP"
  default     = "10.3.0.1"
}

variable "proxy_private_ips" {
  description = "List of Proxy private ip adresses"
  type        = "list"
}

variable "proxy_hostnames" {
  description = "List of Kubernetes proxy hostnames"
  type        = "list"
}

variable "etcd_private_ips" {
  description = "List of Etcd private ip adresses"
  type        = "list"
}

variable "etcd_hostnames" {
  description = "List of Etcd hostnames"
  type        = "list"
}

variable "master_private_ips" {
  description = "List of Kubernetes master private ip adresses"
  type        = "list"
}

variable "master_hostnames" {
  description = "List of Kubernetes master hostnames"
  type        = "list"
}

variable "node_private_ips" {
  description = "List of Node private ip adresses"
  type        = "list"
}

variable "node_hostnames" {
  description = "List of Kubernetes node hostnames"
  type        = "list"
}

variable "cert_path" {
  description = "Certificates storage path"
  default     = "ssl"
}