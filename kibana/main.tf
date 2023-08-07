module "kibana_data_volume" {
  source    = "../_modules/volume"
  name      = local.kibana_volume_name
  namespace = var.namespace

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "kibana_network_policy" {
  source    = "../_modules/network-policy"
  name      = local.kibana_network_policy_name
  namespace = var.namespace

  pod_selector = {
    app = local.kibana_deployment_name
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
      port     = 5601
      protocol = "TCP"
    }]
  }
}

module "kibana_service" {
  source    = "../_modules/service"
  name      = local.kibana_service_name
  namespace = var.namespace

  type = "ClusterIP"

  ports = [{
    port        = 80
    target_port = 5601
  }]

  selector = {
    app = local.kibana_deployment_name
  }
}

module "kibana_ingress" {
  source    = "../_modules/ingress"
  name      = local.kibana_ingress_name
  namespace = var.namespace

  annotations = {
    "ingress.kubernetes.io/ssl-redirect" = "false"
  }

  rules = [{
    host = "kibana.unionsquared.lan"
    paths = [{
      path = "/"
      backend = {
        service = {
          name        = module.kibana_service.service.metadata.0.name
          port_number = 80
        }
      }
    }]
  }]
}

module "kibana" {
  source    = "../_modules/deployment"
  name      = local.kibana_deployment_name
  namespace = var.namespace

  labels = {
    app = local.kibana_deployment_name
  }

  containers = [{
    name  = local.kibana_deployment_name
    image = "docker.elastic.co/kibana/kibana:8.9.0"

    env = [for k, v in local.kibana_environment_variables : {
      name  = k
      value = v
    }]

    ports = [{
      container_port = 9200
    }]

    volume_mounts = [{
      name       = "data-volume"
      mount_path = "/usr/share/kibana/data"
    }]
  }]

  volumes = [{
    name = "data-volume"
    persistent_volume_claim = {
      claim_name = module.kibana_data_volume.volume.metadata.0.name
      read_only  = false
    }
  }]
}
