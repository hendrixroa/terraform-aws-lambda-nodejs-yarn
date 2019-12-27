# Lambda Node.js + yarn

Lambda Module with the best security practice prebuilt with yarn installing to add custom modules and libreries from npmjs.com, ideally to integrate to CI/CD pipeline. Some features:

- Integrated with S3 bucket to deploy latest version and compare if a lambda require update.
- Best security best practices witn encryption features.
- Easy handle to packaging zip + node_modules folder.
- Terraform `0.12.+`

## How to use

```hcl
module "my-lambda" {
  source       = "hendrixroa/lambda-nodejs-yarn/aws"
  code_location        = "../mylambdas/lambda"
  key_s3_bucket        = "lambda.zip"
  s3_bucket_id         = aws_s3_bucket.lambdas.id
  lambda_iam_role      = aws_iam_role.lambda_basic_role.arn
  lambda_function_name = "lambda"
  lambda_runtime       = "nodejs10.x"
  kms_key_logs         = "kms key arn for logs"
  kms_key_lambda       = "kms key arn for lambda"

  environment_variables = {
    myAwesomeEnv = "my awesome value"
  }
}
```

- Basic IAM Role and Policy:

```hcl
resource "aws_iam_role" "lambda_basic_role" {
  name = "lambda_basic_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_basic_policy" {
  name = "lambda_basic_policy"
  role = aws_iam_role.lambda_basic_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

```
