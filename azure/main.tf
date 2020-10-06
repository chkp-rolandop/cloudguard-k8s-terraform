terraform {
  backend "azurerm" {
    resource_group_name  = var.backendrg
    storage_account_name = var.backendsa
    container_name       = var.backendcontainer
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  #ensure that you are logged in to azure via azure-cli or
  #Specify the following environment variables;
  #	ARM_CLIENT_ID
  #	ARM_ENVIRONMENT
  #	ARM_SUBSCRIPTION_ID
  #	ARM_TENANT_ID
  #	ARM_CLIENT_SECRET
}

module "akscluster" {
  source             = "./modules/akscluster"
  ssh_key            = var.ssh_key
  location           = var.location
  kubernetes_version = var.kubernetes_version
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