resource "kubernetes_service_v1" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    allocate_load_balancer_node_ports = var.allocate_load_balancer_node_ports
    cluster_ip                        = var.cluster_ip
    cluster_ips                       = var.cluster_ips
    external_ips                      = var.external_ips
    external_name                     = var.external_name
    external_traffic_policy           = var.external_traffic_policy
    health_check_node_port            = var.health_check_node_port
    internal_traffic_policy           = var.internal_traffic_policy
    ip_families                       = var.ip_families
    ip_family_policy                  = var.ip_family_policy
    load_balancer_class               = var.load_balancer_class
    load_balancer_ip                  = var.load_balancer_ip
    load_balancer_source_ranges       = var.load_balancer_source_ranges
    publish_not_ready_addresses       = var.publish_not_ready_addresses
    selector                          = var.selector
    session_affinity                  = var.session_affinity
    type                              = var.type

    dynamic "port" {
      for_each = var.ports
      content {
        app_protocol = port.value.app_protocol
        name         = port.value.name
        node_port    = port.value.node_port
        port         = port.value.port
        protocol     = port.value.protocol
        target_port  = port.value.target_port
      }
    }
  }
}
