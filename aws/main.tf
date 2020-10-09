terraform {
  #This block specifies using an Azure Storage container to store Terraform state files
  #This block can be removed or commented out if you want to store files locally
  #for more info visit https://www.terraform.io/docs/backends/types/azurerm.html
  /*
	  backend "s3" {
    bucket = "rolop-terraform-backend"
    key    = "kubernetes/terraform.state"
    region = "us-east-1"
  }
*/
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    dome9 = {
      source  = "dome9/dome9"
      version = "~> 1.20.4"
    }
  }
}
provider "aws" {
  region = var.location
}

module "akscluster" {
  source             = "./modules/ekscluster"
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
