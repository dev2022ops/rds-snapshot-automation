data "archive_file" "create_snapshot" {
  type        = "zip"
  source_file = "${path.module}/../lambda/create_snapshot/lambda_function.py"
  output_path = "${path.module}/create_snapshot.zip"
}

data "archive_file" "check_snapshot" {
  type        = "zip"
  source_file = "${path.module}/../lambda/check_snapshot/lambda_function.py"
  output_path = "${path.module}/check_snapshot.zip"
}

resource "aws_lambda_function" "create_snapshot" {
  function_name    = "${var.project_name}-create-snapshot"
  filename         = data.archive_file.create_snapshot.output_path
  source_code_hash = data.archive_file.create_snapshot.output_base64sha256
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      DB_INSTANCE_ID = "rds-backup-lab"
    }
  }
}

resource "aws_lambda_function" "check_snapshot" {
  function_name    = "${var.project_name}-check-snapshot"
  filename         = data.archive_file.check_snapshot.output_path
  source_code_hash = data.archive_file.check_snapshot.output_base64sha256
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_role.arn
}
