# This Terraform configuration sets up the backend to use Amazon S3 for storing the Terraform state file.
# - `bucket`: Specifies the name of the S3 bucket where the state file will be stored.
# - `key`: Defines the path within the bucket where the state file will be saved.
# - `region`: Indicates the AWS region where the S3 bucket is located.
# - `encrypt`: Ensures that the state file is encrypted at rest in the S3 bucket.
terraform {
  backend "s3" {
    bucket = "awsfebucket0001"
    key    = "github-actions-demo.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

