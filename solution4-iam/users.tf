resource "aws_iam_user" "user2" {
  name = "test-user-2"
  path = "/"

  tags = {
    tag-key = "terraform"
  }
}

resource "aws_iam_user_policy_attachment" "policy_attach" {
  for_each   = local.iam_policies
  user       = aws_iam_user.user2.name
  policy_arn = aws_iam_policy.iam_policy[each.key].arn
}
