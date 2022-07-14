module "lambda" {
  source        = "./modules/lambda"
  function_name = "demo-function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  source_folder = "${path.module}/lambda_code"
}