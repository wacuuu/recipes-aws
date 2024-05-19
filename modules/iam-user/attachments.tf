resource "aws_iam_user_policy_attachment" "s3_rw" {
  count      = var.attach_s3_rw ? 1 : 0
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.s3_rw[0].arn
}
