locals {
  notary_deployment_name      = format("%s-app", var.name)
  notary_ingress_name         = format("%s-ingress", var.name)
  notary_mongo_container_name = format("%s-mongo", var.name)
  notary_mongo_service_name   = format("%s-mongo-service", var.name)
  notary_mongo_volume_name    = format("%s-mongo-volume", var.name)
  notary_network_policy_name  = format("%s-netpol", var.name)
  notary_service_name         = format("%s-service", var.name)
  notary_volume_name          = format("%s-volume", var.name)

  mongo_environment_variables = {
    MONGO_INITDB_ROOT_PASSWORD = var.mongo_credentials.admin_password
    MONGO_INITDB_ROOT_USERNAME = var.mongo_credentials.admin_account
  }

  notary_environment_variables = {
    NOTARY_APPLICATION_KEY = ""
    NOTARY_DB_SERVER       = ""
    NOTARY_DB_DATABASE     = "notary"
    NOTARY_DB_USER         = ""
    NOTARY_DB_PASS         = ""
    NOTARY_SALT            = ""
    NOTARY_SALT_ITERATION  = 2048
    NOTARY_HASH_LENGTH     = 32
  }
}
