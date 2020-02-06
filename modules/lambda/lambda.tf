variable "LAMBDA_VARIABLES" {
  type = "map"
}

variable "LAMBDA_SETTINGS" {
  type = "map"
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/function/${var.LAMBDA_SETTINGS["source_file"]}"
  output_path = "${path.module}/function/${var.LAMBDA_SETTINGS["function_name"]}.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "${var.LAMBDA_SETTINGS["function_name"]}"
  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "${var.LAMBDA_SETTINGS["handler"]}"
  runtime          = "${var.LAMBDA_SETTINGS["runtime"]}"

  environment {
    variables = "${var.LAMBDA_VARIABLES}"
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda_${var.LAMBDA_SETTINGS["function_name"]}"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}
