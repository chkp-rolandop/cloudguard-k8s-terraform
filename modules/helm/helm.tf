provider "helm" {
  kubernetes {
		load_config_file        = "false"
		host                    = var.host    
		client_certificate      = var.client_certificate
		client_key              = var.client_key
		cluster_ca_certificate  = var.cluster_ca_certificate
  }
}

resource "helm_release" "cloudguard" {
  name							= "redis"
  chart							= "cp-resource-management"
	repository				= "https://raw.githubusercontent.com/CheckPointSW/charts/master/repository/"

	namespace					= var.namespace
	create_namespace	= "true"

	set {
    name  = "credentials.user"
    value = var.access_id
		type = "string"
  }

	set {
    name  = "credentials.secret"
		value = var.secret_key
		type = "string"
  }
	set {
    name  = "clusterID"
		value = var.clustername
		type = "string"
  }
}
