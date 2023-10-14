locals {
  homeassistant_deployment_name     = format("%s-app", var.name)
  homeassistant_ingress_name        = format("%s-ingress", var.name)
  homeassistant_service_name        = format("%s-service", var.name)
  homeassistant_network_policy_name = format("%s-netpol", var.name)
  homeassistant_volume_name         = format("%s-data-volume", var.name)

  homeassistant_environment_variables = {}
}
