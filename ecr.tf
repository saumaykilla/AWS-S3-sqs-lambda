resource "aws_ecr_repository" "repository" {
  name                 = "${var.naming_convention}-${var.service_name}-repository"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.repository.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire  older images by count "
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = 3
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}


resource "null_resource" "initial_ecr_push" {

  depends_on = [aws_ecr_repository.repository]

  provisioner "local-exec" {
    command = <<-EOT
      DUMMY_IMAGE_URI="${aws_ecr_repository.repository.repository_url}:latest"
      # Pull a minimal image (like busybox or a small Alpine-based image)
      docker pull public.ecr.aws/lambda/python:3.12 
      docker tag public.ecr.aws/lambda/python:3.12 $DUMMY_IMAGE_URI
      aws ecr get-login-password --region ${var.aws_region} --profile ${var.profile} | docker login --username AWS --password-stdin ${aws_ecr_repository.repository.repository_url}
      docker push $DUMMY_IMAGE_URI
    EOT
  }

}