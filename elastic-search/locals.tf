locals {
  es_deployment_name         = format("%s-es", var.name)
  es_ingress_name            = format("%s-ingress", var.name)
  es_service_name            = format("%s-es-service", var.name)
  es_network_policy_name     = format("%s-es-netpol", var.name)
  es_volume_name             = format("%s-es-data-volume", var.name)
  kibana_deployment_name     = format("%s-kibana", var.name)
  kibana_ingress_name        = format("%s-kibana-ingress", var.name)
  kibana_service_name        = format("%s-kibana-service", var.name)
  kibana_network_policy_name = format("%s-kibana-netpol", var.name)
  kibana_volume_name         = format("%s-kibana-data-volume", var.name)

  es_environment_variables = {
    "node.name"                         = format("%s-es-01", var.name)
    "node.store.allow_mmap"             = "false"
    "cluster.name"                      = format("%s-es", var.name)
    "ELASTIC_PASSWORD"                  = var.es_superuser_password
    "bootstrap.memory_lock"             = "true"
    "discovery.type"                    = "single-node"
    "http.cors.enabled"                 = "true"
    "http.cors.allow-origin"            = "\"*\""
    "http.cors.allow-methods"           = "OPTIONS,GET,POST,PUT,DELETE"
    "http.cors.allow-credentials"       = "true"
    "http.cors.allow-headers"           = "X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization,Host"
    "xpack.security.enabled"            = "true"
    "xpack.security.http.ssl.enabled"   = "false"
    "xpack.license.self_generated.type" = "basic"
  }

  kibana_environment_variables = {
    "SERVERNAME"             = format("%s-kibana-01", var.name)
    "ELASTICSEARCH_HOSTS"    = format("http://%s", local.es_service_name)
    "ELASTICSEARCH_USERNAME" = var.kibana_service_account.login
    "ELASTICSEARCH_PASSWORD" = var.kibana_service_account.password
  }
}
