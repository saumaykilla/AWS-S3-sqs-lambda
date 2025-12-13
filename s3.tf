resource "aws_s3_bucket" "bucket" {
  bucket = "${var.naming_convention}-${var.service_name}-bucket"
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  queue {
    queue_arn = aws_sqs_queue.queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}


resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.sqs_processor.arn
  batch_size       = 1
  enabled          = true
  scaling_config {
    maximum_concurrency = 10
  }
}

