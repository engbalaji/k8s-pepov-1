vpc_id                  = "vpc-7b68d01c"
subnet_id_a             = "subnet-0ff5c989c518709f2"
subnet_id_b             = "subnet-062bb23fd3643b174"
environment             = "devc"
kubernetes_version      = "1.30"
cloud_services_role_arn = "arn:aws:iam::126328229668:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_AWSAdministratorAccess_2e76ade949f8e6d0"
alternate_role_arn      = "arn:aws:iam::126328229668:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_AWS-RCINP-WebMT_ff981d3ce6c61029"
ami_id                  = "ami-027eb1e605e40dcbc"
min_node_cpu_count      = 2
max_node_cpu_count      = 4
min_node_mem_GiB        = 2
max_node_mem_GiB        = 16
cluster_min_capacity    = 1
cluster_max_capacity    = 3
aws_region              = "us-west-2"
cluster_cidr            = "172.16.0.0/20"
instance_types = [
  "m5.large",
  "m5a.large",
  "m6i.large",
  "m6a.large"
]
management_network_cidr                   = "10.167.30.99/32"
security_group_revision_one_change_number = "CHG0485472"
