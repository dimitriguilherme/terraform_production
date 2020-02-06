#provedor
provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.cred}"
  profile                 = "${var.profile}"
}

# module "lambda" {
#   source           = "modules/lambda"
#   LAMBDA_SETTINGS  = "${var.HELLO_LAMBDA["settings"]}"
#   LAMBDA_VARIABLES = "${var.HELLO_LAMBDA["variables"]}"
# }

##### cria lambda role
resource "aws_iam_role" "iam_for_lambdalalala" {
  name = "iam_for_lambdalalala"

  assume_role_policy = <<EOF
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
}

#policy iam
resource "aws_iam_role_policy" "iam_for_lambdalalala" {
  name = "iam_for_lambdalalala"
  role = "${aws_iam_role.iam_for_lambdalalala.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}





#cria lambda function
resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function_payload.zip"
  function_name    = "lambda-lalala-terra"
  role             = "${aws_iam_role.iam_for_lambdalalala.arn}"
  handler          = "lalala1"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"
  runtime          = "python3.7"
  timeout          = "120"
  memory_size      = "256"

  tags = {
    tagteste    = "mapteste"
    description = "Tags_used"
  }

  environment {
    variables = {
      foo  = "bar"
      asd  = "asd"
      bbb  = "bbb"
      lala = "lalala"
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.b.arn}"
}

#cria o s3
resource "aws_s3_bucket" "b" {
  bucket = "my-lambda1010bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

#cria os events no s3
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.b.id}"

  lambda_function {
   # id = "send_to_lambda_structed"
    lambda_function_arn = "${aws_lambda_function.test_lambda.arn}"
    events              = ["s3:ObjectCreated:Put"]
    filter_prefix       = "ZenDesk/"
#   filter_suffix       = ".log"
  }

  lambda_function {
  #  id = "send_to_lambda_aaaaaaa"
    lambda_function_arn = "${aws_lambda_function.test_lambda2.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "hehehe"
#   filter_suffix       = ".log"
  }
}



############2

#cria lambda function2
resource "aws_lambda_function" "test_lambda2" {
  filename         = "lambda_function_payload.zip"
  function_name    = "lambda-eeeeee"
  role             = "${aws_iam_role.iam_for_lambdalalala.arn}"
  handler          = "lalala2"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"
  runtime          = "python3.7"
  timeout          = "120"
  memory_size      = "256"

  tags = {
    tagteste    = "mapteste"
    description = "Tags_used"
  }

  environment {
    variables = {
      foo  = "bar"
      asd  = "asd"
      bbb  = "bbb"
      lala = "lalala"
    }
  }
}





resource "aws_lambda_permission" "allow_bucket2" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda2.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.b.arn}"
}
























##cria sns
# resource "aws_sns_topic" "user_updates" {
#   name = "email-notification-lalala"


#   delivery_policy = <<EOF
# {
#   "http": {
#     "defaultHealthyRetryPolicy": {
#       "minDelayTarget": 20,
#       "maxDelayTarget": 20,
#       "numRetries": 3,
#       "numMaxDelayRetries": 0,
#       "numNoDelayRetries": 0,
#       "numMinDelayRetries": 0,
#       "backoffFunction": "linear"
#     },
#     "disableSubscriptionOverrides": false,
#     "defaultThrottlePolicy": {
#       "maxReceivesPerSecond": 1
#     }
#   }
# }
# EOF
# }


# #sns topico
# resource "aws_sns_topic_policy" "default" {
#   arn = "${aws_sns_topic.user_updates.arn}"


#   policy = "${data.aws_iam_policy_document.sns-topic-policy.json}"
# }


# data "aws_iam_policy_document" "sns-topic-policy" {
#   policy_id = "__default_policy_ID"


#   statement {
#     actions = [
#       "SNS:Subscribe",
#       "SNS:SetTopicAttributes",
#       "SNS:RemovePermission",
#       "SNS:Receive",
#       "SNS:Publish",
#       "SNS:ListSubscriptionsByTopic",
#       "SNS:GetTopicAttributes",
#       "SNS:DeleteTopic",
#       "SNS:AddPermission",
#     ]


#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceOwner"


#       values = [
#         "arn:aws:iam::535327618565:dimitri",
#       ]
#     }


#     effect = "Allow"


#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }


#     resources = [
#       "${aws_sns_topic.user_updates.arn}",
#     ]


#     sid = "__default_statement_ID"
#   }
# }


#######################################
#cria instancia
# resource "aws_instance" "example" {
#   ami           = "ami-064a0193585662d74"
#   instance_type = "t2.micro"


#  key_name = "${aws_key_pair.my-key.key_name}" 
#  security_groups = ["${aws_security_group.allow_ssh.name}"]
#}
#
#resource "aws_key_pair" "my-key" {
#  key_name = "my-key"
#  public_key = "${file("/home/vader/lalalaD.pub")}"
#}
# resource "aws_security_group" "allow_ssh" {
#   name = "allow_ssh"
#
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# output "example_public_dns" {
#   value = "${aws_instance.example.public_dns}"
# }
#


#bucket backend not work
# terraform {
#   backend "s3" {
#     bucket  = "mybucket"
#     key     = "terraform.tfstate"
#     region  = "us-east-1"
#     encrypt = true
#     profile = "default"
#   }
# }


#######################################

