resource "aws_iam_policy" "s3_rw" {
  count  = var.attach_s3_rw ? 1 : 0
  name   = "${var.name}-s3-rw"
  policy = data.aws_iam_policy_document.s3_rw[0].json
}

locals {
  buckets_rw = [for i in var.buckets_for_rw : "${i}/*"]
}


data "aws_iam_policy_document" "s3_rw" {
  count = var.attach_s3_rw ? 1 : 0
  statement {
    sid = "1"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject"
    ]
    resources = flatten([
      var.buckets_for_rw,
      local.buckets_rw
    ])
  }

}
