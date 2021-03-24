variable "host" {
}

variable "client_certificate" {
}

variable "client_key" {
}

variable "cluster_ca_certificate" {
}

variable "service_account_access_id" {
}

variable "service_account_secret_key" {
}

variable "clusterID" {
}

variable "namespace" {
	default = "checkpoint"
}

variable "imageRegistryuser" {
  default = "checkpoint+consec_read"
}

variable "imageRegistrypassword" {
}

variable "repository" {
	default = "https://raw.githubusercontent.com/CheckPointSW/charts/master/repository/"
}
