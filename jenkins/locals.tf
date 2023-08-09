locals {
  jenkins_deployment_name     = format("%s-jenkins", var.name)
  jenkins_ingress_name        = format("%s-ingress", var.name)
  jenkins_service_name        = format("%s-jenkins-service", var.name)
  jenkins_network_policy_name = format("%s-jenkins-netpol", var.name)
  jenkins_volume_name         = format("%s-jenkins-data-volume", var.name)
}
