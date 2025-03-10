output "aws_iam_policy_names" {
  value = [ for k in keys(local.iam_policies) : aws_iam_policy.iam_policy[k].name ]
}


