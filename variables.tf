variable "aws_region" {
  description = "The AWS region to deploy the resources to"
  type        = string
  default     = "us-east-2"
}

variable "profile" {
  description = "The AWS profile to use for the resources"
  type        = string
  default     = "default"
}

variable "service_name" {
  description = "The name of the service"
  type        = string
}


variable "naming_convention" {
  description = "The naming convention to use for the resources"
  type        = string
  default     = "prod"
  validation {
    condition     = contains(["sit", "uat", "prod"], var.naming_convention)
    error_message = "Invalid naming convention. Valid values are  sit, uat, prod."
  }
}