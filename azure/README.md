# cloudguard-k8s-terraform for Azure

## Description

This terraform project deploys an AKS cluster with 2 nodes using the terraform azurerm_kubernetes_cluster resource.  A simple web app container is deployed using the terraform kubernetes provider.  The cluster is then onboarded into CloudGuard CSPM using the helm provider.

## Requirements

- Authentication into Azure (use Azure CLI or service principal)
- SSH Key

### Optional

There is a terraform block in main.tf that specifies an Azure Storage Container to store the terraform backend.
This is useful when you plan to make changes to the environment from multiple locations or CI tools.
To use this block, you need to create a Storage container in Azure and provide the necessary values:

    resource_group_name  = "<STORAGE_ACCOUNT_RESOURCE_GROUP>"
    storage_account_name = "<STORAGE_ACCOUNT_NAME>"
    container_name       = "<STORAGE_CONTAINER_NAME>"


## Usage

```bash
terraform apply -var ssh_key="$SSH_KEY" -var access_id="$CHKP_CLOUDGUARD_ID" -var secret_key="$CHKP_CLOUDGUARD_SECRET"
```
This was tested using the following terraform and provider versions:

Terraform v0.13.2
+ provider registry.terraform.io/hashicorp/azurerm v2.30.0
+ provider registry.terraform.io/hashicorp/helm v1.3.1
+ provider registry.terraform.io/hashicorp/kubernetes v1.13.2
+ provider registry.terraform.io/hashicorp/random v2.3.0
+ provider registry.terraform.io/terraform-providers/dome9 v1.20.4
