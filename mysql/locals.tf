locals {
  mysql_deployment_name     = format("%s-db", var.name)
  mysql_ingress_name        = format("%s-ingress", var.name)
  mysql_service_name        = format("%s-service", var.name)
  mysql_network_policy_name = format("%s-netpol", var.name)
  mysql_volume_name         = format("%s-data-volume", var.name)

  mysql_environment_variables = {
    "MYSQL_ROOT_PASSWORD" = "${var.admin_password}"
  }
}
