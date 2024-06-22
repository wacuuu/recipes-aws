resource "aws_iam_role" "lambda_role" {
  name = "${var.name}-LambdaECRRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })

  inline_policy {
    name = "ECRPullPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
          ],
          Effect   = "Allow",
          Resource = aws_ecr_repository.notifier.arn
        },
      ],
    })
  }
}

resource "aws_iam_role_policy_attachment" "basic_exec" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "ecr_lambda" {
  depends_on    = [null_resource.build_and_push]
  function_name = "${var.name}-discord-notify"
  role          = aws_iam_role.lambda_role.arn

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.notifier.repository_url}:${random_string.random.result}"

  environment {
    variables = {
      DISCORD_WEBHOOK = var.discord_hook
    }
  }
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.ecr_lambda.function_name}"
  retention_in_days = 1
}
