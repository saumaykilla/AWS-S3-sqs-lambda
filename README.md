# AWS S3 SQS Lambda 🚀☁️

**Infrastructure as Code for Serverless File Processing Pipeline**

A complete Terraform configuration for setting up a serverless file processing pipeline using AWS S3, SQS, and Lambda with automated event-driven architecture.

---

## 🌟 Features

- 📦 **S3 Event Triggering** - Automatically process files uploaded to S3
- 📨 **SQS Queue Management** - Reliable message queuing for async processing
- ⚡ **Lambda Functions** - Serverless compute for file processing
- 🔄 **Event-Driven** - Fully automated workflow
- 📊 **Scalable** - Auto-scaling based on workload
- 🔐 **Secure** - IAM roles and policies included
- 💰 **Cost-Effective** - Pay only for what you use

---

## 🛠️ Tech Stack

**Infrastructure:**
- Terraform (100% HCL)
- AWS Services:
  - S3 (Simple Storage Service)
  - SQS (Simple Queue Service)
  - Lambda (Serverless Compute)
  - IAM (Identity and Access Management)
  - CloudWatch (Monitoring and Logging)

---

## 📊 Language Composition

```
HCL: 100%
```

---

## 📋 Architecture

```
┌──────────────────────┐
│   File Upload        │
│   to S3 Bucket       │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   S3 Event           │
│   Notification       │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   SQS Queue          │
│   (Buffering)        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Lambda Function    │
│   (Processing)       │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Process Complete   │
│   (Output Storage)   │
└──────────────────────┘
```

---

## 🚀 Quick Start

### Prerequisites

- Terraform 1.0+
- AWS CLI configured with credentials
- AWS account with appropriate permissions

### Installation

```bash
# Clone the repository
git clone https://github.com/saumaykilla/AWS-S3-sqs-lambda.git
cd AWS-S3-sqs-lambda

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan
```

### Deploy

```bash
# Apply infrastructure
terraform apply

# Confirm with 'yes' when prompted
```

### Destroy

```bash
# Remove all resources
terraform destroy

# Confirm with 'yes' when prompted
```

---

## 📁 File Structure

```
AWS-S3-sqs-lambda/
├── main.tf              # Main configuration
├── variables.tf         # Input variables
├── outputs.tf          # Output values
├── iam.tf              # IAM roles and policies
├── s3.tf               # S3 configuration
├── sqs.tf              # SQS configuration
├── lambda.tf           # Lambda configuration
├── terraform.tfvars    # Variable values (example)
└── README.md
```

---

## 🔧 Configuration

### Variables

Edit `terraform.tfvars`:

```hcl
aws_region                 = "us-east-1"
s3_bucket_name            = "my-file-bucket"
sqs_queue_name            = "file-processing-queue"
lambda_function_name      = "file-processor"
lambda_memory_size        = 256
lambda_timeout            = 60
environment_tags = {
  Environment = "production"
  Project     = "file-processing"
}
```

### Outputs

After deployment, view outputs:

```bash
terraform output
```

Key outputs:
- S3 bucket name
- SQS queue URL
- Lambda function ARN
- IAM role ARN

---

## 📊 Resource Details

### S3 Configuration
- Bucket versioning enabled
- Server-side encryption (SSE-S3)
- Block public access
- Event notifications to SQS

### SQS Configuration
- Standard queue with FIFO option available
- Configurable message retention (default: 4 days)
- Visibility timeout set for Lambda processing
- Dead-letter queue support (optional)

### Lambda Configuration
- Runtime: Python/Node.js (configurable)
- Memory: Configurable (128MB - 10GB)
- Timeout: Configurable
- VPC optional
- Environment variables support

### IAM Security
- Least privilege principle
- Service-specific permissions
- Resource-based policies
- Encryption key access

---

## 🔒 Security Considerations

- ✅ S3 bucket public access blocked
- ✅ Encryption enabled by default
- ✅ IAM roles follow least privilege
- ✅ CloudWatch logs encrypted
- ✅ VPC endpoint support available
- ✅ KMS encryption optional

---

## 📊 Monitoring

View CloudWatch logs:

```bash
aws logs tail /aws/lambda/file-processor --follow
```

CloudWatch metrics available:
- Lambda invocations
- SQS messages processed
- S3 object count
- Error rates

---

## 🛠️ Common Commands

```bash
# Initialize workspace
terraform init

# Validate syntax
terraform validate

# Format code
terraform fmt -recursive

# Plan changes
terraform plan -out=tfplan

# Apply specific resource
terraform apply -target aws_s3_bucket.main

# Destroy specific resource
terraform destroy -target aws_lambda_function.processor

# Output specific value
terraform output sqs_queue_url
```

---

## 📝 Customization

### Add Lambda Environment Variables

In `lambda.tf`:

```hcl
environment {
  variables = {
    ENV_VAR_1 = "value1"
    ENV_VAR_2 = "value2"
  }
}
```

### Enable Dead-Letter Queue

```hcl
redrive_policy = jsonencode({
  deadLetterTargetArn = aws_sqs_queue.dlq.arn
  maxReceiveCount     = 3
})
```

### Add VPC Support

Configure in `lambda.tf`:

```hcl
vpc_config {
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}
```

---

## 🚀 Best Practices

1. **State Management**
   - Store `terraform.tfstate` remotely (S3 + DynamoDB)
   - Enable state locking
   - Version control excluded

2. **Deployment**
   - Use `terraform plan` before apply
   - Review all changes carefully
   - Implement gradual rollouts

3. **Monitoring**
   - Enable CloudWatch alarms
   - Set up log retention
   - Monitor Lambda cold starts

4. **Cost Optimization**
   - Adjust Lambda memory/timeout
   - Configure SQS retention policy
   - Use S3 lifecycle policies

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/Enhancement`)
3. Test changes (`terraform validate && terraform plan`)
4. Commit changes (`git commit -m 'Add Enhancement'`)
5. Push to branch (`git push origin feature/Enhancement`)
6. Open Pull Request

---

## 📝 License

MIT License - see LICENSE file for details

---

## 📚 Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/)
- [AWS SQS Documentation](https://docs.aws.amazon.com/sqs/)
- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)

---

## 📞 Support

For issues or questions:
- Open a GitHub issue
- Email: [saumay.killa@gmail.com](mailto:saumay.killa@gmail.com)

---

<div align="center">

**Serverless Infrastructure Made Simple**

Made with ❤️ by Saumay Killa

[⬆ back to top](#aws-s3-sqs-lambda-)

</div>
