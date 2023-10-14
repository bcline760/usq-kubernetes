locals {
  mosquitto_configuration_name  = format("%s-conf", var.name)
  mosquitto_deployment_name     = format("%s-app", var.name)
  mosquitto_ingress_name        = format("%s-ingress", var.name)
  mosquitto_log_volumne_name    = format("%s-log-volume", var.name)
  mosquitto_network_policy_name = format("%s-netpol", var.name)
  mosquitto_password_name       = format("%s-pwd", var.name)
  mosquitto_service_name        = format("%s-service", var.name)
  mosquitto_volume_name         = format("%s-data-volume", var.name)

  mosquitto_environment_variables = {}
}
