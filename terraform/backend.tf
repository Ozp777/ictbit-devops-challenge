terraform {
  backend "s3" {
    bucket = "ictbit-terraform-state-12345"
    key    = "ictbit-devops-challenge/terraform.tfstate"
    region = "eu-central-1"
  }
}
