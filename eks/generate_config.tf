data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig.tpl")
  vars = {
    endpoint            = data.aws_eks_cluster.cluster.endpoint
    cluster_auth_base64 = data.aws_eks_cluster.cluster.certificate_authority[0].data
    kubeconfig_name     = module.eks.cluster_name
    token               = data.aws_eks_cluster_auth.cluster.token
    cluster_name        = module.eks.cluster_name
  }
}

resource "local_file" "kubeconfig" {
  lifecycle {
    ignore_changes = [content]
  }
  content  = data.template_file.kubeconfig.rendered
  filename = "kubeconfig.yaml"
}

provider "kubernetes" {
  config_path = "./kubeconfig.yaml"
}
