variable "code_location" {
  description = "Folder code"
}

variable "s3_bucket_id" {
  description = "S3 bucket to save the lambda code"
}

variable "key_s3_bucket" {
  description = "key value of s3 object"
}

variable "lambda_function_name" {
  description = "Lambda function name"
}

variable "lambda_runtime" {
  description = "Lambda runtime of function"
}

variable "lambda_iam_role" {
  description = "Lambda IAM role"
}

variable "environment_variables" {
  description = "Environment variables for lambda function"
  default     = {}
  type        = "map"
}

variable "subnets" {
  description = "Subnets"
  default     = []
  type        = "list"
}

variable "sg_ids" {
  description = "Security groups"
  default     = []
  type        = "list"
}

variable "kms_key_logs" {
  description = "KMS Key for logs encryption"
}

variable "kms_key_lambda" {
  description = "KMS Key for lambda encryption"
}
