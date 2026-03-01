# Amazon Bedrock - Pay-as-you-go (on-demand) model
# No provisioning needed - you pay per token when you invoke models

resource "aws_iam_user" "bedrock" {
  name = var.bedrock_user_name
}

resource "aws_iam_user_policy_attachment" "bedrock_limited" {
  user       = aws_iam_user.bedrock.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockLimitedAccess"
}

resource "aws_iam_service_specific_credential" "bedrock" {
  user_name     = aws_iam_user.bedrock.name
  service_name  = "bedrock.amazonaws.com"
}
