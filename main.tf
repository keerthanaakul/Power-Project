provider "aws" {
  region = "us-east-1"
}
# Define the Lambda function
resource "aws_lambda_function" "my_lambda_function" {
  filename      = data.archive_file.lambda.output_path
  function_name = "my-lambda-function"
  role          = aws_iam_role.lambda_role.arn
}
