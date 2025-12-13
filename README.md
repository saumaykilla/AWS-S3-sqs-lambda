# AWS Serverless File Processing Infrastructure

This project contains Terraform configuration to provision a serverless architecture on AWS. It sets up an S3 bucket for file uploads, which triggers an SQS queue, which in turn triggers a Lambda function (container-based) to process the events.

## Architecture Overview

1.  **S3 Bucket**: Stores uploaded files. Triggers an event notification on `s3:ObjectCreated:*`.
2.  **SQS Queue**: Buffers events from S3.
3.  **ECR Repository**: Host the Docker image for the Lambda function.
4.  **Lambda Function**: Consumes messages from the SQS queue and processes files from S3.

## Prerequisites

Before running this project, ensure you have the following installed and configured:

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0.0)
- [AWS CLI](https://aws.amazon.com/cli/) (configured with appropriate credentials)
- [Docker](https://www.docker.com/) (running, as it is required to push the initial image to ECR)

**Note:** The `ecr.tf` file includes a `local-exec` provisioner that runs Docker commands to pull a base Python image and push it to the newly created ECR repository. This ensures the Lambda function has a valid image to start with.

## Project Structure

- `ecr.tf`: Provisions the Elastic Container Registry (ECR) and handles the initial image push.
- `lambfa.tf`: Configures the AWS Lambda function, IAM roles, and policies.
- `s3.tf`: sets up the S3 bucket and event notifications to SQS. Also configures the Lambda event source mapping.
- `sqs.tf`: Sets up the SQS queue and its resource policy.
- `variables.tf`: Defines input variables and validation rules.
- `providers.tf`: Terraform provider configuration.

## Inputs

| Name                | Description                       | Type     | Default         | Options                                                     |
| ------------------- | --------------------------------- | -------- | --------------- | ----------------------------------------------------------- |
| `aws_region`        | AWS region to deploy resources to | `string` | `us-east-2`     |                                                             |
| `environment`       | Deployment environment            | `string` | `prod`          | `sit`, `uat`, `prod`                                        |
| `naming_convention` | Naming prefix for resources       | `string` |             
 `sit`, `uat`, `prod` |

## Usage

1.  **Initialize Terraform**

    ```bash
    terraform init
    ```

2.  **Review the Plan**

    ```bash
    terraform plan
    ```

3.  **Apply the Configuration**

    ```bash
    terraform apply
    ```

    _During the apply phase, Terraform will create the ECR repository, use Docker to push a dummy image (python:3.12), and then deploy the Lambda function using that image._

## Resources Created

- **AWS ECR Repository**: `${naming_convention}-generate-ui-repository`
- **AWS S3 Bucket**: `${naming_convention}-generate-ui-bucket`
- **AWS SQS Queue**: `${naming_convention}-generate-ui-queue`
- **AWS Lambda Function**: `${naming_convention}-sqs-processor`
- **IAM Roles & Policies**:
  - Lambda execution role with permissions to read from SQS, read from S3, and write to CloudWatch Logs.

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

_Note: S3 buckets containing objects may trigger errors during destruction. Ensure the bucket is empty before running destroy, or manually delete the bucket contents._
