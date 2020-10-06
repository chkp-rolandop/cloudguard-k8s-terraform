variable "tf-state-backend-bucket" {
}

variable "location" {
  default = "us-central1"
}

variable "credentialsfile" {
  default = "account.json"
}

variable "projectname" {
  default = "CloudGuard Lab"
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
