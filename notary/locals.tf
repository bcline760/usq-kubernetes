locals {
  notary_deployment_name     = format("%s-app", var.name)
  notary_ingress_name        = format("%s-ingress", var.name)
  notary_service_name        = format("%s-service", var.name)
  notary_network_policy_name = format("%s-netpol", var.name)
  notary_volume_name         = format("%s-data-volume", var.name)
  notary_tls_name            = format("%s-tls", var.name)

  notary_environment_variables = {
    "ASPNETCORE_ENVIRONMENT"             = "Production"
    "AzureAd__ClientId"                  = var.service_principal.client_id
    "AzureAd__ClientSecret"              = var.service_principal.client_secret
    "AzureAd__Domain"                    = var.service_principal.domain
    "AzureAd__TenantId"                  = var.service_principal.tenant_id
    "Notary__ApplicationKey"             = var.app_key
    "Notary__Database__ConnectionString" = var.database.connection_string
    "Notary__Database__DatabaseName"     = var.database.name
  }
}
