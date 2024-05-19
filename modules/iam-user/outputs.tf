output "access_key" {
  value = var.create_access_key ? aws_iam_access_key.this[0].id : null
}

output "secret_key" {
  value = var.create_access_key ? aws_iam_access_key.this[0].secret : null
}
