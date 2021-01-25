terraform {
  backend "http" {
    address       = "[ADD YOUR OBJECT STORAGE HERE]"
    update_method = "PUT"
  }

  required_providers {
    kubernetes = { version = "1.13.3" }
    helm       = { version = "1.3.2" }
    oci        = { version = "3.97.0" }
  }
}

provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

provider "kubernetes" {
  alias            = "okecluster"
  load_config_file = "true"
  config_path      = "./generated/kubeconfig"
}

provider "helm" {
  alias = "cloudguard"
  kubernetes {
    config_path = "./generated/kubeconfig"
  }
}

resource "random_pet" "prefix" {
}

module "oke" {
  source       = "oracle-terraform-modules/oke/oci"
  version      = "3.0.0-RC2"
  label_prefix = "${random_pet.prefix.id}-cp"
  # insert the 8 required variables here
  api_fingerprint                      = var.fingerprint
  api_private_key_path                 = var.private_key_path
  compartment_id                       = var.compartment_ocid
  use_encryption                       = var.use_encryption
  existing_key_id                      = var.existing_key_id
  region                               = var.region
  kubernetes_version                   = var.kubernetes_version
  service_account_cluster_role_binding = var.service_account_cluster_role_binding
  tenancy_id                           = var.tenancy_ocid
  user_id                              = var.user_ocid
  bastion_enabled                      = false
  operator_enabled                     = false
  ssh_private_key_path                 = var.ssh_private_key_path
  ssh_public_key_path                  = var.ssh_public_key_path
}

module "k8s" {
  source = "./modules/k8s"
  providers = {
    kubernetes = kubernetes.okecluster
  }
  depends_on = [module.oke]
}

module "cgcspm" {
  source     = "./modules/cgcspm"
  access_id  = var.access_id
  secret_key = var.secret_key
  name       = "${random_pet.prefix.id}-cp"
  ou         = var.ou
}

module "helm" {
  source = "./modules/helm"
  providers = {
    helm = helm.cloudguard
  }
  depends_on = [module.oke]
  repository = var.repository
  access_id  = var.access_id
  secret_key = var.secret_key
  clusterID  = module.cgcspm.clusterID
}
