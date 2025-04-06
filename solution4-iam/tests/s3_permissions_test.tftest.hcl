variables {
  test_user_name = "test-user-2"
}

# Test IAM user creation
run "test_user_creation" {
  command = plan

  assert {
    condition = aws_iam_user.user2.name == var.test_user_name
    error_message = "IAM user name does not match expected value"
  }
}

# Test S3 bucket list policy content
run "test_s3_list_policy_content" {
  command = plan

  assert {
    condition = (
      jsondecode(aws_iam_policy.iam_policy["s3_read_access"].policy).Statement[0].Effect == "Allow" &&
      contains(jsondecode(aws_iam_policy.iam_policy["s3_read_access"].policy).Statement[1].Action, "s3:ListBucket")
    )
    error_message = "Policy does not have correct S3 list bucket permissions"
  }
}

# Test policy attachment
run "test_policy_attachment" {
  command = plan

  assert {
    condition = (
      aws_iam_user_policy_attachment.policy_attach["s3_read_access"].user == var.test_user_name &&
      aws_iam_user_policy_attachment.policy_attach["s3_read_access"].policy_arn == aws_iam_policy.iam_policy["s3_read_access"].arn
    )
    error_message = "Policy s3_read_access is not correctly attached to the user"
  }
}

# Test complete configuration
# run "test_complete_configuration" {
#   command = apply

#   assert {
#     condition = (
#       aws_iam_user.user2.name == var.test_user_name &&
#       aws_iam_policy.policy_s3_read_access.name == "test_policy" &&
#       aws_iam_user_policy_attachment.user2_policy_attachment.user == var.test_user_name
#     )
#     error_message = "Complete IAM configuration does not match expected state"
#   }
# }
