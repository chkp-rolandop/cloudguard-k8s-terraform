variable "location" {
  default = "us-east-1"
}

variable "kubernetes_version" {
  default = "1.18.8"
}

variable "ssh_key" {
}

variable "access_id" {
}

variable "secret_key" {
}

variable "service_account_access_id" {
}

variable "service_account_secret_key" {
}

variable "ou" {
  default=""
}

variable imageRegistrypassword {
}

variable "repository" {
  default = "https://raw.githubusercontent.com/CheckPointSW/charts/ea/repository/"
}
