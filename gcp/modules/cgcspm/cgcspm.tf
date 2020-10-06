provider "dome9" {
  dome9_access_id     = var.access_id
  dome9_secret_key    = var.secret_key
}

resource "dome9_cloudaccount_kubernetes" "demo" {
  name  = var.name
  organizational_unit_id = var.ou
}
