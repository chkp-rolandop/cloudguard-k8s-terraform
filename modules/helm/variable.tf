variable "host" {
}

variable "client_certificate" {
}

variable "client_key" {
}

variable "cluster_ca_certificate" {
}

variable "access_id" {
}

variable "secret_key" {
}

variable "clusterID" {
}

variable "namespace" {
	default = "checkpoint"
}

variable "repository" {
	default = "https://raw.githubusercontent.com/CheckPointSW/charts/master/repository/"
}
