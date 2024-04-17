provider "aws" {
  region = var.aws_region == "" ? var.AWS_DEFAULT_REGION : var.aws_region
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_s3_bucket" "lambda_code" {
  bucket = "power-testing-s3"
}

resource "null_resource" "lambda_packager" {
  triggers = {
    version = filemd5("lambda_function.py")
    bucket_name = aws_s3_bucket.lambda_code.bucket # Store the bucket name
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      echo "Removing existing zip file..."
      rm -f function.zip
      echo "Creating new zip file..."
      zip -r9 function.zip lambda_function.py || { echo "Failed to create zip file"; exit 1; }
      echo "Uploading zip file to S3..."
      aws s3 cp function.zip s3://${self.triggers.bucket_name}/function.zip || { echo "Failed to upload zip file"; exit 1; }
      echo "Operation completed successfully."
    EOT
  }

}

resource "aws_lambda_function" "python_lambda" {
  function_name = "MyPythonLambdaFunction"

  s3_bucket = aws_s3_bucket.lambda_code.bucket
  s3_key    = "function.zip"

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn
}
