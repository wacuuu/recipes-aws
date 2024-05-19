resource "aws_iam_user" "this" {
  name          = var.name
  force_destroy = var.force_destroy
}
resource "aws_iam_access_key" "this" {
  count = var.create_access_key ? 1 : 0
  user  = aws_iam_user.this.name
}
