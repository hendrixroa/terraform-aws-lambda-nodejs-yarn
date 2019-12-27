// Zip file to upload function lambda
data "archive_file" "main" {
  type        = "zip"
  source_dir  = var.code_location
  output_path = "${path.module}/.terraform/archive_files/${var.key_s3_bucket}"

  depends_on = ["null_resource.main"]
}

// Provisioner to install dependencies in lambda package before upload it.
resource "null_resource" "main" {

  triggers = {
    updated_at = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    yarn config set no-progress
    yarn
    EOF

    working_dir = var.code_location
  }
}

resource "aws_s3_bucket_object" "main" {
  bucket = var.s3_bucket_id
  key    = var.key_s3_bucket
  source = data.archive_file.main.output_path
  etag   = data.archive_file.main.output_base64sha256

  depends_on = [
    data.archive_file.main,
  ]
}

resource "aws_lambda_function" "main" {
  s3_bucket        = var.s3_bucket_id
  s3_key           = var.key_s3_bucket
  function_name    = var.lambda_function_name
  role             = var.lambda_iam_role
  handler          = "index.handler"
  source_code_hash = data.archive_file.main.output_base64sha256
  runtime          = var.lambda_runtime
  kms_key_arn      = var.kms_key_lambda

  environment {
    variables = var.environment_variables
  }

  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = var.sg_ids
  }

  depends_on = [
    "aws_s3_bucket_object.main",
  ]
}

// CloudWatch logs to stream all module
resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
  kms_key_id        = var.kms_key_logs
}
