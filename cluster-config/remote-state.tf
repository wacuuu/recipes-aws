data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "${path.module}/../eks/terraform.tfstate"
  }
}

data "terraform_remote_state" "networking" {
  backend = "local"
  config = {
    path = "${path.module}/../networking/terraform.tfstate"
  }
}
