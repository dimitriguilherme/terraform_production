variable "cred" {
  default = ".aws/credentials"
}

variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "default"
}

variable "HELLO_LAMBDA" {
  type = "map"

  default = {
    settings = {
      function_name = "hello_lambda-MODULE"
      handler       = "hello_lambda.lambda_handler"
      runtime       = "python3.6"
      source_file   = "hello_lambda.py"
    }

    variables = {
      greeting = "Hello"
    }
  }
}
