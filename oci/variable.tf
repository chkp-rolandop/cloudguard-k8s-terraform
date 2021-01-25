variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "compartment_ocid" {
}

variable "region" {
  default = "us-ashburn-1"
}

variable "use_encryption" {
  default = "true"
}

variable "existing_key_id" {
  default = ""
}

variable "service_account_cluster_role_binding" {
  default = ""
}
variable "ssh_private_key_path" {
}

variable "ssh_public_key_path" {
}

variable "kubernetes_version" {
  default = "v1.17.13"
}

variable "repository" {
}

variable "access_id" {
}

variable "secret_key" {
}

variable "ou" {
}
