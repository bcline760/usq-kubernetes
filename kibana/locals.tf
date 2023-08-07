locals {
  kibana_deployment_name     = format("%s-kibana", var.name)
  kibana_ingress_name        = format("%s-kibana-ingress", var.name)
  kibana_service_name        = format("%s-kibana-service", var.name)
  kibana_network_policy_name = format("%s-kibana-netpol", var.name)
  kibana_volume_name         = format("%s-kibana-data-volume", var.name)

  kibana_environment_variables = {
    "SERVERNAME"             = format("%s-kibana-01", var.name)
    "ELASTICSEARCH_HOSTS"    = format("http://%s-es-service", var.name)
    "ELASTICSEARCH_USERNAME" = var.kibana_service_account.login
    "ELASTICSEARCH_PASSWORD" = var.kibana_service_account.password
  }
}
