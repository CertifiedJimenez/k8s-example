resource "random_password" "wordpress" {
  length  = 24
  special = false
}

resource "random_password" "mariadb_root" {
  length  = 24
  special = false
}

resource "random_password" "mariadb" {
  length  = 24
  special = false
}

resource "aws_secretsmanager_secret" "wordpress" {
  name                    = "${var.cluster_name}/wordpress"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "wordpress" {
  secret_id = aws_secretsmanager_secret.wordpress.id

  # Default credentials based on the Bitnami WordPress Docker image defaults
  # See: https://hub.docker.com/r/bitnami/wordpress (WORDPRESS_USERNAME, WORDPRESS_EMAIL, WORDPRESS_PASSWORD)
  secret_string = jsonencode({
    wordpress-username = var.wordpress_username
    wordpress-email    = var.wordpress_email
    wordpress-password = random_password.wordpress.result
  })
}

resource "aws_secretsmanager_secret" "mariadb" {
  name                    = "${var.cluster_name}/mariadb"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mariadb" {
  secret_id = aws_secretsmanager_secret.mariadb.id

  secret_string = jsonencode({
    mariadb-root-password = random_password.mariadb_root.result
    mariadb-password      = random_password.mariadb.result
  })
}

module "eso_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.cluster_name}-eso"

  role_policy_arns = {
    secrets = aws_iam_policy.eso_secrets.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["external-secrets:external-secrets"]
    }
  }
}

resource "aws_iam_policy" "eso_secrets" {
  name = "${var.cluster_name}-eso-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
      Resource = [
        aws_secretsmanager_secret.wordpress.arn,
        aws_secretsmanager_secret.mariadb.arn,
      ]
    }]
  })
}
