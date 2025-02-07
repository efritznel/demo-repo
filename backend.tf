terraform {
  backend "s3" {
    bucket = "awsfebucket0001"
    key    = "github-actions-demo.tfstate"
    region = "us-east-1"
  }
}

