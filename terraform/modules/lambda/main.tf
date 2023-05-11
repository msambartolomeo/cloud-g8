resource "aws_security_group" "lambda" {
  name        = local.security_group_name
  description = "Generic Lambda Security Group"
  vpc_id      = var.vpc_id

  # TODO: add rules if needed
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# FIXME: error creating IAM role
resource "aws_iam_role" "lambda" {
  name               = "lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "self" {
  for_each = var.lambdas

  filename      = each.value.path
  function_name = each.value.name
  role          = aws_iam_role.lambda.arn
  handler       = each.value.handler
  runtime       = var.runtime

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  tags = {
    Name = "lambda-${each.value.name}"
  }

  depends_on = [aws_security_group.lambda, aws_iam_role.lambda]
}
