terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-us-east-1-test"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
