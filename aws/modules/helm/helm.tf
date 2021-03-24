provider "helm" {
  kubernetes {
		load_config_file       = "false"
		host                   = var.host
    access_token           = var.access_token
		cluster_ca_certificate = var.cluster_ca_certificate
  }
}

resource "helm_release" "cloudguard" {
  name							= "cloudguard"
  chart							= "cloudguard"
	repository				= var.repository

	namespace					= var.namespace
	create_namespace	= "true"

	set {
    name  = "credentials.user"
    value = var.service_account_access_id
		type = "string"
  }

	set {
    name  = "credentials.secret"
		value = var.service_account_secret_key
		type = "string"
  }

	set {
    name  = "clusterID"
		value = var.clusterID
		type = "string"
  }

	set {
    name  = "addons.imageUploader.enabled"
		value = "true"
  }

	set {
    name  = "addons.flowLogs.enabled"
		value = "true"
  }

  set {
    name  = "addons.imageScan.enabled"
    value = "true"
  }

  set {
    name  = "addons.runtimeProtection.enabled"
    value = "true"
  }

  set {
    name  = "addons.admissionControl.enabled"
    value = "true"
  }

  set {
    name  = "imageRegistry.user"
    value = var.imageRegistryuser
  }

  set {
    name  = "imageRegistry.password"
    value = var.imageRegistrypassword
  }
}
