resource "aws_iam_policy" "iam_policy" {
  for_each    = local.iam_policies
  name        = format("%s-tf", each.value.name)
  path        = "/"
  description = each.value.description

  policy = file(each.value.file)

  tags = {
    PolicyDescription = each.value.description
  }
}


resource "aws_iam_user_policy_attachment" "policy_attach" {
  for_each   = local.iam_policies
  user       = aws_iam_user.user2.name
  policy_arn = aws_iam_policy.iam_policy[each.key].arn
}

resource "aws_iam_policy" "s3_deny_bucket_policy" {
  name        = "s3-deny-bucket-policy"
  description = "Policy to deny access to specific S3 bucket in us-west-2"
  policy      = file("${path.module}/policies/s3-deny-bucket.json")
}

# Attach the policy to the test user
resource "aws_iam_user_policy_attachment" "s3_deny_bucket_policy_attach" {
  user       = aws_iam_user.user2.name
  policy_arn = aws_iam_policy.s3_deny_bucket_policy.arn
}
