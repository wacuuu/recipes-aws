data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "test-cluster"
  cluster_version = "1.26"

  cluster_endpoint_public_access        = false
  cluster_additional_security_group_ids = [aws_security_group.extra_sg.id]

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.networking.outputs.private_subnets.*.id
  control_plane_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnets.*.id

  self_managed_node_group_defaults = {
    attach_cluster_primary_security_group  = true
    instance_type                          = "t3.xlarge"
    key_name                               = aws_key_pair.node_keypair.key_name
    update_launch_template_default_version = true
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }

  self_managed_node_groups = {
    one = {
      max_size     = 5
      desired_size = 2
    }
  }

  manage_aws_auth_configmap = true
  create_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      username = "admin"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]

}
