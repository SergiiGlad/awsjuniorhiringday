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