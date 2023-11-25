data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "${path.module}/../eks/terraform.tfstate"
  }
}
