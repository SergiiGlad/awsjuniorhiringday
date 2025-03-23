variables {
  test_user_name = "test-user-2"
}

# Test user creation and permissions
run "create_user_with_s3_list_permission" {
  command = plan

  # Create test user
  variables {
    test_user_name = var.test_user_name
  }

  assert {
    condition = aws_iam_user.user2.name == var.test_user_name
    error_message = "User name does not match expected value"
  }
}

# # Test S3 bucket list permissions
# run "test_s3_list_permissions" {
#   command = apply

#   # Create policy for S3 list buckets
#   variables {
#     test_user_name = var.test_user_name
#   }

#   assert {
#     condition = can(data.aws_iam_policy_document.test_s3_list.json)
#     error_message = "Failed to create S3 list bucket policy"
#   }
# }
