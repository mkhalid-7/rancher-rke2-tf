
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


# cluster config #
cloud_credential_name = "mkhalid-credentials"
cluster_name = "rke2-tf-test"
kubernetes_version = "v1.32.3+rke2r1"
# kubernetes_version = "v1.28.15+rke2r1"


# rke2 pool config
# 1
pool_1_name = "pool1"
pool_1_machines = 3
# 2
# pool_2_name = "pool2"
# pool_2_machines = 1

