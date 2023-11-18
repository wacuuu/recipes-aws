terraform {
  backend "local" {}
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  default_tags {
    tags = {
      Component = "networking"
    }
  }
}
