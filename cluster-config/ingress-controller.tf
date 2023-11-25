data "template_file" "private_ingress_controller" {
  template = file("${path.module}/ingress-controller-values.yaml")
  vars = {
    sg_id = aws_security_group.internal_lb.id
  }
}

resource "helm_release" "private_ingress_controller" {
  name       = "private-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.8.3"
  namespace  = "private-ingress-controller"
  values = [
    data.template_file.private_ingress_controller.rendered
  ]
  create_namespace = true
}

resource "aws_security_group" "internal_lb" {
  name   = "internal-lb"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
