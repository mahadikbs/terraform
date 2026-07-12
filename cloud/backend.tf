terraform {
    backend "s3" {
        bucket = "bm-terraform-state-bucket"
        key = "terraform.tfstate"
        dynamodb_table = "tfstate-lock"
        region = "us-east-1"
    }
}