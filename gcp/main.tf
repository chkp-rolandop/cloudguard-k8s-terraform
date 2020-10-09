terraform {

  /*
  backend "gcs" {
    bucket = "rolop-terraform-backend"
    prefix = "terraform/state"
  }
*/
  required_providers {
    dome9 = {
      source  = "dome9/dome9"
      version = "~> 1.20.4"
    }
  }
}

provider "google" {
  project = var.projectid
  region  = var.location
}

module "gkecluster" {
  source   = "./modules/gkecluster"
  location = var.location
}

module "k8s" {
  source                 = "./modules/k8s"
  host                   = "https://${module.gkecluster.kubernetes_cluster_endpoint}"
  access_token           = "${module.gkecluster.access_token}"
  cluster_ca_certificate = "${base64decode(module.gkecluster.cluster_ca_certificate)}"
}

module "cgcspm" {
  source     = "./modules/cgcspm"
  access_id  = var.access_id
  secret_key = var.secret_key
  name       = "${module.gkecluster.kubernetes_cluster_name}"
  ou         = var.ou
}

module "helm" {
  source                 = "./modules/helm"
  host                   = "https://${module.gkecluster.kubernetes_cluster_endpoint}"
  access_token           = "${module.gkecluster.access_token}"
  cluster_ca_certificate = "${base64decode(module.gkecluster.cluster_ca_certificate)}"
  repository             = var.repository
  access_id              = var.access_id
  secret_key             = var.secret_key
  clusterID              = "${module.cgcspm.clusterID}"
}
