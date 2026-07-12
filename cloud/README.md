# Terraform cloud

Note: This configuration uses the S3 backend with `use_lockfile = true`. In recent Terraform releases this accepts a boolean value. Ensure your CI runner uses a Terraform version that supports `use_lockfile` as a boolean (Terraform 1.7+ recommended).
