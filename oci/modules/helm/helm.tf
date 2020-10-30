resource "helm_release" "cloudguard" {
  name       = "cloudguard"
  chart      = "cp-resource-management"
  repository = var.repository

  namespace        = var.namespace
  create_namespace = "true"

  set {
    name  = "credentials.user"
    value = var.access_id
    type  = "string"
  }

  set {
    name  = "credentials.secret"
    value = var.secret_key
    type  = "string"
  }

  set {
    name  = "clusterID"
    value = var.clusterID
    type  = "string"
  }

  set {
    name  = "addons.imageUploader.enabled"
    value = "true"
  }

  set {
    name  = "addons.flowLogs.enabled"
    value = "true"
  }
}
