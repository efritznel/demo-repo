terraform {
  backend "s3" {
    bucket = "awsfebucket0001"
    key    = "github-actions-demo.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}