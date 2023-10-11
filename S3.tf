terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
resource "aws_s3_bucket" "s3-terraform" {
  bucket = "my-s3-terraform-bucket10923"
  acl= "private"
}