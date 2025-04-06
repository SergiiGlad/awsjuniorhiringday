terraform {
  backend "s3" {
    bucket = "test-bucket-1677123456-abc123"
    key    = "terraform/terraform.state"
    region = "us-west-2"
  }
}
