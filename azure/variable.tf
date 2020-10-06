variable "backendrg" {
}

variable "backendsa" {
}

variable "backendcontainer" {
}
variable "location" {
  default = "East US 2"
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

variable "ou" {
}

variable "repository" {
  default = "https://raw.githubusercontent.com/CheckPointSW/charts/master/repository/"
}
