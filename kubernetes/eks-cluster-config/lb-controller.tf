module "lb_controller_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.32"

  role_name = "loadbalancer-controller-role"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.eks.outputs.oidc_provider_arn
      namespace_service_accounts = ["lb-controller:lb-controller", "lb-controller:lb-controller"]
    }
  }
}

data "template_file" "lb_controller_values" {
  template = file("${path.module}/lb-controller-values.yaml")
  vars = {
    role_arn     = module.lb_controller_role.iam_role_arn
    cluster_name = data.terraform_remote_state.eks.outputs.cluster_name
  }
}

resource "helm_release" "lb_controller" {
  name       = "lb-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.6.2"
  namespace  = "lb-controller"
  values = [
    data.template_file.lb_controller_values.rendered
  ]
  create_namespace = true
}
