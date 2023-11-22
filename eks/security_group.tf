resource "aws_security_group" "extra_sg" {
  name   = "eks-allow-local"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.vpc_cidr]
  }
}
