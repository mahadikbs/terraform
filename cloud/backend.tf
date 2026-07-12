terraform {
    backend "s3" {
        bucket = "bm-terraform-state-bucket"
        key = "terraform.tfstate"
        use_lockfile = "tfstate-lock"
        region = "us-east-1"
    }
}