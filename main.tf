# Existing AmazonEC2 cloud credential
data "rancher2_cloud_credential" "aws_credentials" {
  name = var.cloud_credential_name
}


# Create AmazonEC2 machine config v2
resource "rancher2_machine_config_v2" "aws-machine-config" {
  generate_name = "aws-machine-config"
  amazonec2_config {
    region = var.region
    instance_type = var.instance_type
    iam_instance_profile = var.iam_instance_profile
    ssh_user =  var.ssh_user    # default ubuntu
    volume_type = var.volume_type
    root_size =  var.root_disk_size     # default 16
    ami =  var.ami_id
    security_group = [ "${var.security_group_name}" ]
    subnet_id = var.subnet_id
    vpc_id = var.vpc_id
    zone = var.zone
  }
}


# # Create rke2 cluster  
resource "rancher2_cluster_v2" "rke2_cluster" {
  name                         = var.cluster_name
  kubernetes_version           = var.kubernetes_version
  enable_network_policy        = false
  cloud_credential_secret_name = data.rancher2_cloud_credential.aws_credentials.id

  rke_config {
    machine_global_config = yamlencode({
      cni = var.cni_name
    })

    dynamic "machine_pools" {
      for_each = var.node_groups
      content {
        name                         = machine_pools.key
        cloud_credential_secret_name = data.rancher2_cloud_credential.aws_credentials.id
        quantity                     = machine_pools.value.quantity
        control_plane_role           = machine_pools.value.control_plane_role
        etcd_role                    = machine_pools.value.etcd_role
        worker_role                  = machine_pools.value.worker_role
        machine_labels               = machine_pools.value.machine_labels
        annotations                  = machine_pools.value.machine_annotations

        dynamic "taints" {
          for_each = machine_pools.value.machine_taints
          content {
            key    = taints.value.key
            value  = taints.value.value
            effect = taints.value.effect
          }
        }

        machine_config {
          kind = rancher2_machine_config_v2.aws-machine-config.kind
          name = rancher2_machine_config_v2.aws-machine-config.name
        }
      }
    }
  }

  depends_on = [rancher2_machine_config_v2.aws-machine-config]
}













# 

