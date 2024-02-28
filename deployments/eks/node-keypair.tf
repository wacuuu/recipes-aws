module "keypair" {
  source = "../../modules/instance_keypair"
  name   = "eks-nodes"
}
