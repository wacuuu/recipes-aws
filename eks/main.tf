data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20"

  cluster_name    = "test-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access        = false
  cluster_additional_security_group_ids = [aws_security_group.extra_sg.id]

  cluster_addons = {
    coredns = {
      addon_version = "v1.10.1-eksbuild.6"
    }
    kube-proxy = {
      addon_version = "v1.27.6-eksbuild.2"
    }
    vpc-cni = {
      addon_version = "v1.15.5-eksbuild.1"
    }
  }

  vpc_id                   = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.networking.outputs.private_subnets
  control_plane_subnet_ids = data.terraform_remote_state.networking.outputs.private_subnets

  self_managed_node_group_defaults = {
    bootstrap_extra_args                   = "--use-max-pods false --kubelet-extra-args '--max-pods=110'"
    vpc_security_group_ids                 = [aws_security_group.extra_sg.id]
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
