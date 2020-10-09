# cloudguard-k8s-terraform/gcp

Notes: If you recieved the following error:

```bash
Error: clusterroles.rbac.authorization.k8s.io is forbidden: User "682958793986-compute@developer.gserviceaccount.com" cannot create resource "clusterroles" in API group "rbac.authorization.k8s.io" at the cluster scope: requires one of ["container.clusterRoles.create"] permission(s).

  on modules/helm/helm.tf line 10, in resource "helm_release" "cloudguard":
  10: resource "helm_release" "cloudguard" 
```

You need to add Kubernetes Cluster Admin permissions to the google account you are using.  In my case I was using the Compute Engine default service account and it did not have this permission by default.

