output "aws_iam_policy_names" {
  value = [ for k in keys(local.iam_policies) : aws_iam_policy.iam_policy[k].name ]
}

# output "test" {
#   value = {
#     test1: jsondecode(aws_iam_policy.iam_policy["s3_read_access"].policy).Statement[0].Effect == "Allow"
#     test2: aws_iam_user_policy_attachment.policy_attach["s3_read_access"].user == "test-user-2" && aws_iam_user_policy_attachment.policy_attach["s3_read_access"].policy_arn == aws_iam_policy.iam_policy["s3_read_access"].arn
#   }
# }

