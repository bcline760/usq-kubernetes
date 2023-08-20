locals {
  os_deployment_name     = format("%s-os", var.name)
  os_ingress_name        = format("%s-ingress", var.name)
  os_service_name        = format("%s-os-service", var.name)
  os_network_policy_name = format("%s-os-netpol", var.name)
  os_volume_name         = format("%s-os-data-volume", var.name)

  os_environment_variables = {
    "bootstrap.memory_lock"             = "true"
    "cluster.name"                      = format("%s-os", var.name)
    "DISABLE_INSTALL_DEMO_CONFIG"       = "true"
    "DISABLE_SECURITY_PLUGIN"           = "true"
    "discovery.type"                    = "single-node"
    "node.name"                         = format("%s-os-01", var.name)
    "OPENSEARCH_JAVA_OPTS"              = "-Xms1024m -Xmx1024m"
    "plugins.security.ssl.http.enabled" = "false"
  }
}
