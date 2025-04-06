resource "aws_iam_user" "user2" {
  name = var.user_name
  path = "/"

  tags = {
    tag-key = "terraform"
  }
}
