terraform {
  backend "gcs" {
    bucket  = var.tf-state-backend-bucket
    prefix  = "terraform/state"
  }
}

 provider "google" {
  credentials = file(var.credentialsfile)
  project     = var.projectname
  region      = var.location
} 

module "gkecluster" {
  source             = "./modules/gkecluster"
  ssh_key            = var.ssh_key
  location           = var.location
  min_master_version = var.kubernetes_version
}

module "k8s" {
  source                 = "./modules/k8s"
  host                   = "${module.akscluster.host}"
  client_certificate     = "${base64decode(module.akscluster.client_certificate)}"
  client_key             = "${base64decode(module.akscluster.client_key)}"
  cluster_ca_certificate = "${base64decode(module.akscluster.cluster_ca_certificate)}"
}

module "cgcspm" {
  source     = "./modules/cgcspm"
  access_id  = var.access_id
  secret_key = var.secret_key
  name       = "${module.akscluster.kubernetes_cluster_name}"
  ou         = var.ou
}

module "helm" {
  source                 = "./modules/helm"
  host                   = "${module.akscluster.host}"
  client_certificate     = "${base64decode(module.akscluster.client_certificate)}"
  client_key             = "${base64decode(module.akscluster.client_key)}"
  cluster_ca_certificate = "${base64decode(module.akscluster.cluster_ca_certificate)}"
  repository             = var.repository
  access_id              = var.access_id
  secret_key             = var.secret_key
  clusterID              = "${module.cgcspm.clusterID}"
}
