locals {
  iam_policies = {
    s3_read_access = {
      name        = "S3CreateListReadPolicy"
      description = "Policy create list and read S3 buckets"
      file        = "policies/s3-read-policy.json"
    }
    lambda_delete = {
      name        = "LambdaDeletePolicy"
      description = "Policy delete lambda functions"
      file        = "policies/lambda-del.json"
    }
    lambda_read = {
      name        = "LambdaReadPolicy"
      description = "Policy read lambda functions"
      file        = "policies/lambda-read.json"
    }
    s3_delete_bucket = {
      name        = "S3DeleteBucketPolicy"
      description = "Policy delete S3 buckets"
      file        = "policies/s3-del-bucket.json"
    }
    s3_deny_bucket = {
      name        = "S3DenyDeleteBucketPolicy"
      description = "Policy deny delete S3 test buckets in 5 regions"
      file        = "policies/s3-deny-bucket.json"
    }
  }
}
