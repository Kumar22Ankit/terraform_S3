# Terraform with S3 Backend and Lambda Integration

## Problem Statement

This project demonstrates how to use **Terraform** to manage infrastructure on AWS, with a focus on utilizing **S3** as a backend for state management and **Lambda** for handling custom workflows, such as state locking and unlocking. The goal is to ensure that the Terraform state file is safely stored and managed in S3, while leveraging DynamoDB for state locking, preventing concurrent changes to the state.

## Architecture Overview

- **S3 Bucket**: Used to store the Terraform state file.
- **DynamoDB**: Provides state locking and unlocking functionality to ensure that only one user can modify the state at a time.
- **Lambda Function**: An AWS Lambda function to manage the Terraform state and interact with the S3 bucket and DynamoDB table.
- **IAM Roles & Policies**: Used to define the permissions for the Lambda function to interact with S3 and DynamoDB.

## Infrastructure Components

- **S3 Bucket**: Stores the Terraform state file .
- **DynamoDB Table**: Used for state locking.
- **Lambda Function**: Manages state locking and performs operations on the S3 bucket.
- **IAM Role and Policy**: Assigned to Lambda for permissions.

## Setup Instructions

1. **Clone the Repository**
   
   ```bash
   git clone https://github.com/Kumar22Ankit/terraform_S3.git
   cd terraform_S3
2. **Install Terraform**

- **Ensure that Terraform is installed on your machine. You can download it from here.**

3. **Create S3 Bucket (Manually)**

- **Ensure that you have a pre-existing S3 bucket to store the Terraform state file. The bucket name should be unique globally.**
