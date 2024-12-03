provider "aws" {
  region = "ap-south-1"
}

# S3 Bucket Object 
resource "aws_s3_object" "example" {
  bucket = "terraforms3bucket-dec3"
  key    = "example.txt"
  source = "example.txt"

  
  metadata = {
    lambda_arn = "arn:aws:lambda:ap-south-1:975050186482:function:terraform-state-handler"
  }
}

# DynamoDB Table 
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"  
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "Terraform State"
  }
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.lambda_function_name}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda Access to S3 and DynamoDB
resource "aws_iam_policy" "lambda_policy" {
  name = "${var.lambda_function_name}_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:PutObject"],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::terraforms3bucket-dec3/*"
      },
      {
        Action   = "dynamodb:*",
        Effect   = "Allow",
        Resource = aws_dynamodb_table.terraform_lock.arn
      }
    ]
  })
}

# Attach IAM Policy to Lambda Execution Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


data "aws_lambda_function" "existing_lambda" {
  function_name = "terraform-state-handler"
}


terraform {
  backend "s3" {
    bucket         = "terraforms3bucket-dec3"
    key            = "terraform/state.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}


output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_lock.name
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = data.aws_lambda_function.existing_lambda.function_name
}

