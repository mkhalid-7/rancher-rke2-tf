
# connect to rancher
rancher_url = ""
bearer_token = ""


# aws machine config
region     = "us-east-1"
instance_type = "t2.medium" # 2 vCPU 4 GiB Memory
ami_id = "ami-084568db4383264d4"
ssh_user = "ubuntu"
volume_type = "gp2"
root_disk_size = "16"

iam_instance_profile = "ec2-admin-instance-profile"
security_group_name = "mkhalid-sg"
subnet_id = "subnet-a5c56ee8"
vpc_id = "vpc-9dd3e7e7"
zone = "c"


# cluster config 
cloud_credential_name = "mkhalid-credentials"
cluster_name = "rke2-tf"
cni_name  = "calico"
kubernetes_version = "v1.26.15+rke2r1"
# kubernetes_version = "v1.28.15+rke2r1"
# kubernetes_version = "v1.32.3+rke2r1"


# rke2 pool config
node_groups = {
  master-pool = {
    control_plane_role  = true
    etcd_role           = true
    worker_role         = true
    quantity            = 1
    machine_labels      = {}
    machine_taints      = []
    machine_annotations = {}
  }
  worker-pool = {
    control_plane_role  = false
    etcd_role           = false
    worker_role         = true
    quantity            = 1
    machine_labels      = {}
    machine_taints = [
      # {
      #   key    = "dedicated"
      #   value  = "worker"
      #   effect = "NoSchedule"
      # }
    ]
    machine_annotations = {
      # "cluster.provisioning.cattle.io/autoscaler-max-size" = "5"
    }
  }
}

