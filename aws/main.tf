terraform {
  #This block specifies using an S3 Bucket to store Terraform state files
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
    helm      = {
      source  = "hashicorp/helm"
      version = "~>2.0.3"
    }
    kubernetes      = {
      source  = "hashicorp/kubernetes"
      version = "~>2.0.3"
    }
  }
}

provider "aws" {
  region = var.location
}

resource "random_pet" "prefix" {
}

locals {
  cluster_name = "${random_pet.prefix.id}-cg-eks"
}

data "aws_availability_zones" "available" {
}

data "aws_eks_cluster" "cluster" {
  name = module.ekscluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.ekscluster.cluster_id
}

module "ekscluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "13.2.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.19"
  subnets         = module.eksvpc.private_subnets

  tags          = {
    Environment = "Demo"
  }

  vpc_id = module.eksvpc.vpc_id

  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 5
    }
  ]
}

module "eksvpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name            = "${random_pet.prefix.id}-vpc"
  cidr            = "10.0.0.0/16"
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags                              = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags                             = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "k8s" {
  source                 = "./modules/k8s"
  host                   = data.aws_eks_cluster.cluster.endpoint
  access_token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

module "cgcspm" {
  source     = "./modules/cgcspm"
  access_id  = var.access_id
  secret_key = var.secret_key
  name       = data.aws_eks_cluster.cluster.endpoint
  ou         = var.ou
}

module "helm" {
  source                     = "./modules/helm"
  host                   = data.aws_eks_cluster.cluster.endpoint
  access_token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  repository                 = var.repository
  service_account_access_id = var.service_account_access_id
  service_account_secret_key = var.service_account_secret_key
  imageRegistrypassword      = var.imageRegistrypassword
  clusterID                  = "${module.cgcspm.clusterID}"
}
