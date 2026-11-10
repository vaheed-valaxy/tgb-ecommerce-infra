resource "aws_iam_policy" "kyverno_ecr_policy" {
  name        = "${local.resource_name}-kyverno-ecr-policy"
  description = "Allow Kyverno to read Shopverse ECR repositories"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      # ======================================================
      # ECR Authentication
      # ======================================================
      {
        Sid    = "ECRAuthentication"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      # ======================================================
      # ECR Image Read Access
      # ======================================================
      {
        Sid    = "ECRImageRead"
        Effect = "Allow"

        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability"
        ]

        Resource = "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/shopverse/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kyverno_ecr_policy_attachment" {
  role       = aws_iam_role.kyverno_ecr_role.name
  policy_arn = aws_iam_policy.kyverno_ecr_policy.arn
}
