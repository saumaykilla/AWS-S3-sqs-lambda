resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.naming_convention}-${var.service_name}-lambda-policy"
  policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes"
            ],
            "Resource": "${aws_sqs_queue.queue.arn}"
        },
        {
           "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:ListBucket",
                "s3:ListBucketVersions"
            ],
            "Resource": [
                "${aws_s3_bucket.bucket.arn}",
                "${aws_s3_bucket.bucket.arn}/*"
            ]
        },
        {
        "Effect": "Allow",
        "Action":["logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
        "Effect": "Allow",
        "Action": [
                "bedrock:InvokeModel"
            ],
            "Resource": "*"
        }
        ]
    }
    EOF
}

resource "aws_iam_role" "iam_for_terraform" {
  name = "${var.naming_convention}-${var.service_name}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.iam_for_terraform.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


resource "aws_lambda_function" "sqs_processor" {
  function_name = "${var.naming_convention}-${var.service_name}-sqs-processor"
  role          = aws_iam_role.iam_for_terraform.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.repository.repository_url}:latest"
  timeout       = 300
  memory_size   = 1024

  lifecycle {
    ignore_changes = [image_uri, environment]
  }



  depends_on = [aws_iam_role_policy_attachment.lambda_policy_attachment, null_resource.initial_ecr_push]
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.naming_convention}-${var.service_name}-sqs-processor"
  retention_in_days = 30

}
