# cloudguard-k8s-terraform/oke

## Requirements

- Complete the prerequisites for terraform-oci-oke module: https://github.com/oracle-terraform-modules/terraform-oci-oke/blob/master/docs/prerequisites.adoc
- oci-cli: https://docs.cloud.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm
- (Optional) Terraform Backend Storage: https://docs.cloud.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm
	- uncomment terraform block in main.tf
- CloudGuard CSPM API Key

The following variables should be set:
```bash
	export TF_VAR_tenancy_ocid=
	export TF_VAR_compartment_ocid=
	export TF_VAR_user_ocid=
	export TF_VAR_fingerprint=
	export TF_VAR_private_key_path=~/.oci/oci_api_key.pem
	export TF_VAR_ssh_key=
	export TF_VAR_access_id=
	export TF_VAR_secret_key=
	export TF_VAR_ssh_private_key_path=~/.ssh/id_rsa
	export TF_VAR_ssh_public_key_path=~/.ssh/id_rsa.pub
```
