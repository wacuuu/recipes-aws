module "ebs_driver_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.32"

  role_name = "ebs-driver-role"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.eks.outputs.oidc_provider_arn
      namespace_service_accounts = ["ebs-driver:ebs-driver-node", "ebs-driver:ebs-driver-controller"]
    }
  }
}

data "template_file" "ebs_controller_values" {
  template = file("${path.module}/ebs-driver-values.yaml")
  vars = {
    role_arn = module.ebs_driver_role.iam_role_arn
  }
}

resource "helm_release" "csi_driver" {
  name       = "ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.25.0"
  namespace  = "ebs-driver"
  values = [
    data.template_file.ebs_controller_values.rendered
  ]
  create_namespace = true
}
