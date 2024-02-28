terraform {
  backend "local" {}
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "../eks/kubeconfig.yaml"
  }
}
provider "aws" {
  default_tags {
    tags = {
      Component = "cluster-config"
    }
  }
}
