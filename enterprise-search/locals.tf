locals {
  entsearch_deployment_name     = format("%s-enterprise-app", var.name)
  entsearch_ingress_name        = format("%s-enterprise-ingress", var.name)
  entsearch_service_name        = format("%s-enterprise-service", var.name)
  entsearch_network_policy_name = format("%s-enterprise-netpol", var.name)
  entsearch_volume_name         = format("%s-enterprise-data-volume", var.name)

  entsearch_environment_variables = {
    "allow_es_settings_modification"    = "true"
    "elasticsearch.host"                = var.elasticsearch.host
    "elasticsearch.username"            = var.elasticsearch.username
    "elasticsearch.password"            = var.elasticsearch.password
    "ent_search.external_url"           = var.enterprise_search.url
    "kibana.external_url"               = var.kibana.external_url
    "kibana.host"                       = var.kibana.host
    "KIBANA_HOST"                       = var.kibana.host
    "secret_management.encryption_keys" = format("[%s]", join(",", var.enterprise_search_encryption_keys))
    "SERVER_NAME"                       = format("%s-enterprise-app", var.name)
  }
}
