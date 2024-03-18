provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = "~> 1.6.0"

  backend "s3" {
    bucket         = "terraform-upx-tofu-controller-demo-zkk"
    dynamodb_table = "terraform-upx-tofu-controller-demo-zkk"
    encrypt        = true
    key            = "aws/tofu-controller-demo/eu-central-1/demo-bucket/terraform.tfstate"
    kms_key_id     = "alias/terraform/terraform-upx-tofu-controller-demo-zkk"
    region         = "eu-central-1"
  }
}

resource "aws_s3_bucket" "demo" {
  bucket_prefix = "demo-"
}
