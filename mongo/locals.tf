locals {
  mongo_deployment_name     = format("%s-db", var.name)
  mongo_ingress_name        = format("%s-ingress", var.name)
  mongo_service_name        = format("%s-service", var.name)
  mongo_network_policy_name = format("%s-netpol", var.name)
  mongo_volume_name         = format("%s-data-volume", var.name)

  mongo_environment_variables = {
    "MONGO_INITDB_ROOT_USERNAME" = "${var.admin_credentials.login}"
    "MONGO_INITDB_ROOT_PASSWORD" = "${var.admin_credentials.password}"
  }
}
