resource "aws_sqs_queue" "dlq" {
  name                      = "${var.naming_convention}-${var.service_name}-dlq"
  message_retention_seconds = 1209600
}

resource "aws_sqs_queue" "queue" {
  name                       = "${var.naming_convention}-${var.service_name}-queue"
  visibility_timeout_seconds = 300

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })

  policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": "*",
                "Action": "sqs:SendMessage",
                "Resource": "arn:aws:sqs:*:*:${var.naming_convention}-${var.service_name}-queue",
                "Condition": {
                    "ArnEquals": {  
                        "aws:SourceArn": "${aws_s3_bucket.bucket.arn}"
                    }
                }
            }
        ]
    }
    POLICY
}