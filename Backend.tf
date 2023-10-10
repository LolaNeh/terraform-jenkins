terraform {
  backend "s3" {
    bucket = "firsts3bucket10923"
    key    = "Terraform-state/terraform.tfstate"
    region = "us-west-1"
    encrypt = true 
    dynamodb_table = "terraform-state-lock-dynamo"

  }
}