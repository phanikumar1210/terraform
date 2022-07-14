variable "lambda_role_arn" {
  type        = string
  default     = null
  description = "Name of the Lambda role"
}

variable "function_name" {
  type        = string
  description = "Name of the lambda function"
}

variable "description" {
  type        = string
  default     = "Lambda function created with Terraform"
  description = "Description for lambda function"
}

variable "handler" {
  type        = string
  description = "Handler that need to be used for lambda"
}

variable "memory_size" {
  type        = number
  default     = 128
  description = "Amount of memory that need to be allocated"
}

variable "runtime" {
  type        = string
  description = "Runtime for Lambda function"
}

variable "timeout" {
  type        = number
  default     = 30
  description = "The maximum period upto which Lambda function can be run"
}

variable "s3_bucket" {
  type        = string
  default     = null
  description = "Path of the S3 bucket in which code is available"
}

variable "s3_key" {
  type        = string
  default     = null
  description = "Object name inside S3 which should be used for code"
}

variable "s3_object_version" {
  type        = string
  default     = null
  description = "Object version based on which terraform should decide whether to update lambda code or not"
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "Environment variables that need to be configured for Lambda"
}

variable "vpc_subnet_ids" {
  type        = list(string)
  default     = null
  description = "Subnet ID's that need to be assigned to Lambda"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  default     = null
  description = "Security groups that need to be assigned to Lambda"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of key-value pair based tags that need to be assigned to Lambda"
}

variable "managed_policy_arns" {
  type        = list(string)
  default     = null
  description = "List of managed policy arns that need to be attached to Lambda"
}

variable "architectures" {
  type        = list(string)
  default     = ["x86_64"]
  description = "Architecture that need to be used for Lambda supported values are [\"x86_64\"] and [\"arm64\"]"
}

variable "enable_version" {
  type        = bool
  default     = false
  description = "Whether to enable versioning on Lambda or not"
}

variable "source_file_path" {
  type        = string
  default     = null
  description = "Source file for which "
}

variable "source_folder" {
  type        = string
  default     = null
  description = "description"
}
