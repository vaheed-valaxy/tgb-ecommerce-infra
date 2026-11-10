# HELM Provider
provider "helm" {
  kubernetes = {
    host                   = local.eks_host
    cluster_ca_certificate = base64decode(local.eks_cluster_ca_certificate)
    token                  = local.eks_token  # data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "kyverno" {
  name       = "kyverno"
  repository = "https://kyverno.github.io/kyverno"
  chart      = "kyverno"
  namespace  = "kyverno"

  version = "3.9.1"   # Installs Kyverno 1.19.1

  create_namespace = true

  wait            = true
  timeout         = 600
  cleanup_on_fail = true

  values = [
    yamlencode({
      admissionController = {
        replicas = 1

        serviceAccount = {
          create = true

          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.kyverno_ecr_role.arn
          }
        }
      }

      backgroundController = {
        replicas = 1
      }

      cleanupController = {
        replicas = 1
      }

      reportsController = {
        replicas = 1
      }
    })
  ]

  depends_on = [
    aws_iam_role.kyverno_ecr_role,
    aws_iam_role_policy_attachment.kyverno_ecr_policy_attachment
  ]
}
