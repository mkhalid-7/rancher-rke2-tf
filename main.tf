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


# Create a cluster           
resource "rancher2_cluster_v2" "rke2_cluster" {
  name = var.cluster_name
  kubernetes_version = var.kubernetes_version
  enable_network_policy = false
  cloud_credential_secret_name =  data.rancher2_cloud_credential.aws_credentials.id
  rke_config {
    # Nodes in this pool have control plane role and etcd roles
    machine_pools {
      name = var.pool_1_name
      cloud_credential_secret_name = data.rancher2_cloud_credential.aws_credentials.id
      quantity = var.pool_1_machines
      control_plane_role = true
      etcd_role = true
      worker_role = true
      drain_before_delete = true
      machine_config {
        kind = rancher2_machine_config_v2.aws-machine-config.kind
        name = rancher2_machine_config_v2.aws-machine-config.name
      }
    }
    machine_global_config = yamlencode({
      cni = "calico"
      disable-kube-proxy = false
      etcd-expose-metrics = false
    })
  }
  depends_on = [ rancher2_machine_config_v2.aws-machine-config ]
}





# ############################################
# # Create a new rancher2 Node Template
# resource "rancher2_node_template" "aws_node_template" {
#   name = "aws_node_template"
#   description = "aws ec2"
#   cloud_credential_id = data.rancher2_cloud_credential.aws_credentials.id
#   amazonec2_config {
#     region = var.region
#     instance_type = var.instance_type
#     iam_instance_profile = var.iam_instance_profile
#     ssh_user =  var.ssh_user    # default ubuntu
#     volume_type = var.volume_type
#     root_size =  var.root_disk_size     # default 16
#     ami =  var.ami_id
#     security_group = [ "${var.security_group_name}" ]
#     subnet_id = var.subnet_id
#     vpc_id = var.vpc_id
#     zone = var.zone

#   }
# }

# # Create a cluster with multiple machine pools
# # resource "rancher2_cluster_v2" "rke2_cluster" {
# #   name = var.cluster_name
# #   kubernetes_version = var.kubernetes_version
# #   enable_network_policy = false
# #   cloud_credential_secret_name =  data.rancher2_cloud_credential.aws_credentials.id
# # }

# # Create a new rancher2 RKE Cluster 
# resource "rancher2_cluster" "foo-custom" {
#   name = "foo-custom"
#   description = "Foo rancher2 custom cluster"
  
#   rke_config {
#     network {
#       plugin = "canal"
#     }
#     kubernetes_version =  var.kubernetes_version
#   }
# }


# # Create a new rancher2 Node Pool
# resource "rancher2_node_pool" "pool_1" {
#   depends_on = [ rancher2_cluster.foo-custom]                                                           

#   cluster_id      = rancher2_cluster.foo-custom.id
#   node_template_id = rancher2_node_template.aws_node_template.id
#   name            = var.pool_1_name
#   hostname_prefix = "rke2-cluster-0"
#   quantity        = var.pool_1_machines
#   control_plane   = true
#   etcd            = true
#   worker          = true
# }






#########################################


# 

