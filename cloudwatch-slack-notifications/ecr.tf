resource "aws_ecr_repository" "notifier" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  force_delete = true
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "local_file" "code" {
  filename = "notifier/lambda_function.py"
}
data "local_file" "deps" {
  filename = "notifier/requirements.txt"
}
data "local_file" "dockerfile" {
  filename = "notifier/Dockerfile"
}

resource "null_resource" "refresh_trigger" {
  triggers = {
    code       = data.local_file.code.content_base64
    deps       = data.local_file.deps.content_base64
    dockerfile = data.local_file.dockerfile.content_base64
  }
}

resource "random_string" "random" {
  lifecycle {
    replace_triggered_by = [null_resource.refresh_trigger]
  }

  length  = 8
  special = false
}

resource "null_resource" "build_and_push" {
  lifecycle {
    replace_triggered_by = [random_string.random]
  }
  provisioner "local-exec" {
    working_dir = "./notifier"
    command     = <<EOF
        set -x
        alias docker=podman
        export IMAGE_TAG="${aws_ecr_repository.notifier.repository_url}:${random_string.random.result}"
        docker build -t $IMAGE_TAG .
        aws ecr get-login-password | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com
        docker push $IMAGE_TAG
    EOF
  }
}


