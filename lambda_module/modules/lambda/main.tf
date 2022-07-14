data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "lambda_file" {
  count         = var.source_file_path != null || var.source_folder != null ? 1 : 0
  type          = "zip"
  source_file   = var.source_file_path !=null ? var.source_file_path: null
  source_dir = var.source_folder !=null? var.source_folder : null
  output_path   = "${var.function_name}.zip"
}

resource "aws_iam_role" "lambda" {
  count               = var.lambda_role_arn == null ? 1 : 0
  name                = "${var.function_name}-lambda-role"
  managed_policy_arns = var.managed_policy_arns
  description         = var.description
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags                = merge(var.tags, { ManagedBy = "Terraform" })
}

data "aws_iam_policy_document" "logs_policy" {
  count = var.lambda_role_arn == null ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["aws:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
  }
}

resource "aws_iam_policy" "managed_policy" {
  count = var.lambda_role_arn == null ? 1 : 0

  name   = "${var.function_name}-lambda-logs-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.logs_policy[0].json
  tags   = merge(var.tags, { ManagedBy = "Terraform" })
}

resource "aws_iam_role_policy_attachment" "logs_policy_attachment" {
  count      = var.lambda_role_arn == null ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.managed_policy[0].arn
}

resource "aws_lambda_function" "lambda_function" {
  function_name     = var.function_name
  description       = var.description
  role              = var.lambda_role_arn == null ? aws_iam_role.lambda[0].arn : var.lambda_role_arn
  handler           = var.handler
  memory_size       = var.memory_size
  runtime           = var.runtime
  timeout           = var.timeout
  publish           = var.enable_version
  filename          = var.source_file_path !=null || var.source_folder !=null ? "${var.function_name}.zip" : null
  source_code_hash  = var.source_file_path !=null || var.source_folder !=null ? data.archive_file.lambda_file[0].output_sha : null
  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  s3_object_version = var.s3_object_version

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }
  architectures = var.architectures
  tags          = merge(var.tags, { ManagedBy = "Terraform" })
}