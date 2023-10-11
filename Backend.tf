terraform {
  backend "s3" {
    bucket = "mys3bucket101023"
    key    = "terraform-jenkins/terraform.tfstate"
    region = "us-east-1"
    encrypt = true 
    dynamodb_table = "terraform-state-lock-dynamo"

  }
}