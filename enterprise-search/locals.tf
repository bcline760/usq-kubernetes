locals {
  entsearch_deployment_name     = format("%s-search-app", var.name)
  entsearch_ingress_name        = format("%s-search-ingress", var.name)
  entsearch_service_name        = format("%s-search-service", var.name)
  entsearch_network_policy_name = format("%s-search-netpol", var.name)
  entsearch_volume_name         = format("%s-search-data-volume", var.name)

  entsearch_environment_variables = {
    "allow_es_settings_modification" = "true"
    "SERVER_NAME"                    = format("%s-search-app", var.name)
    "elasticsearch.host"             = var.elasticsearch.host
    "elasticsearch.username"         = var.elasticsearch.username
    "elasticsearch.password"         = var.elasticsearch.password
    "kibana.host"                    = var.kibana.host
    "KIBANA_HOST"                    = var.kibana.host
    "kibana.external_url"            = var.kibana.external_url
    "ent_search.external_url"        = var.enterprise_search.url
  }
}
