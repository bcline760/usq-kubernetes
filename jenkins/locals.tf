locals {
  jenkins_deployment_name     = format("%s-app", var.name)
  jenkins_ingress_name        = format("%s-ingress", var.name)
  jenkins_service_name        = format("%s-service", var.name)
  jenkins_network_policy_name = format("%s-netpol", var.name)
  jenkins_volume_name         = format("%s-data-volume", var.name)

  jenkins_environment_variables = {}
}
