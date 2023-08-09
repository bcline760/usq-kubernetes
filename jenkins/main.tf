module "jenkins_data_volume" {
  source    = "../_modules/volume"
  name      = local.jenkins_volume_name
  namespace = var.namespace

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "jenkins_network_policy" {
  source    = "../_modules/network-policy"
  name      = local.jenkins_network_policy_name
  namespace = var.namespace

  pod_selector = {
    app = local.jenkins_deployment_name
  }

  ports = {
    egress = [{
      port     = 80
      protocol = "TCP"
      }, {
      port     = 443
      protocol = "TCP"
    }]
    ingress = [{
      port     = 50000
      protocol = "TCP"
      }, {
      port     = 8080
      protocol = "TCP"
    }]
  }
}

module "jenkins_service" {
  source    = "../_modules/service"
  name      = local.jenkins_service_name
  namespace = var.namespace

  type = "ClusterIP"

  ports = [{
    port        = 80
    target_port = 8080
  }]

  selector = {
    app = local.jenkins_deployment_name
  }
}
