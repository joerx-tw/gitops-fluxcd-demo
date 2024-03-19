provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = "~> 1.3.9" # Only version supported by TF controller

  backend "s3" {
    bucket         = "terraform-upx-tofu-controller-demo-zkk"
    dynamodb_table = "terraform-upx-tofu-controller-demo-zkk"
    encrypt        = true
    key            = "aws/tofu-controller-demo/eu-central-1/demo-vpc/terraform.tfstate"
    kms_key_id     = "alias/terraform/terraform-upx-tofu-controller-demo-zkk"
    region         = "eu-central-1"
  }
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-central-1"

  vpc_cidr = "10.166.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    maintainer  = "cloud-foundations"
    environment = "development"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.6.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]

  tags = local.tags
}
