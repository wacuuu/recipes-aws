resource "null_resource" "ip_prefixing" {
  provisioner "local-exec" {
    command = "kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true"
    environment = {
      KUBECONFIG = "../eks/kubeconfig.yaml"
    }
  }
}
