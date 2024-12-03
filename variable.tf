variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-state-lock"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function for state operations"
  type        = string
  default     = "terraform-state-handler"
}

