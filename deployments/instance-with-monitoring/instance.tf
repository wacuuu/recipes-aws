module "key" {
  source = "../../modules/instance_keypair"
  name   = "test-instance"
}

module "instance" {
  source        = "../../modules/instance"
  instance_name = "test"
  subnet_id     = module.networking.private_subnets[0]
  key_name      = module.key.key_name
  vpc_id        = module.networking.vpc_id
}
