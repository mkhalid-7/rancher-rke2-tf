
variable "rancher_url" {}
variable "bearer_token" {}
variable "region" {}
variable "instance_type" {}
variable "root_disk_size" {}
variable "ami_id" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "zone" {}
variable "security_group_name" {}
variable "iam_instance_profile" {}
variable "ssh_user" {}
variable "volume_type" {}
variable "kubernetes_version" {}
variable "cloud_credential_name" {}
variable "cluster_name" {}
variable "cni_name" {}

variable "node_groups" {
  type = map(object({
    control_plane_role    = bool
    etcd_role             = bool
    worker_role           = bool
    quantity              = number
    machine_labels        = map(string)
    machine_taints        = list(object({
      key    = string
      value  = string
      effect = string
    }))
    machine_annotations   = map(string)
  }))
}







