module "opensearch_namespace" {
  source = "../_modules/namespace"

  name = var.namespace
}

module "opensearch_data_volume" {
  source    = "../_modules/volume"
  name      = local.os_volume_name
  namespace = module.opensearch_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = var.opensearch.volume.size
  }
}

module "opensearch_service" {
  source    = "../_modules/service"
  name      = local.os_service_name
  namespace = module.opensearch_namespace.namespace.metadata.0.name

  type = "ClusterIP"

  ports = [{
    port        = 80
    target_port = var.opensearch.port
  }]

  selector = {
    app = local.os_deployment_name
  }
}

module "opensearch_ingress" {
  source    = "../_modules/ingress"
  name      = local.os_ingress_name
  namespace = module.opensearch_namespace.namespace.metadata.0.name

  annotations = {
    "ingress.kubernetes.io/ssl-redirect" = "false"
  }

  rules = [{
    host = var.opensearch.host
    paths = [{
      path = "/"
      backend = {
        service = {
          name        = module.opensearch_service.service.metadata.0.name
          port_number = 80
        }
      }
    }]
  }]
}

module "opensearch" {
  source = "../_modules/deployment"

  name      = local.os_deployment_name
  namespace = var.namespace

  containers = [{
    image = "opensearchproject/opensearch:latest"
    name  = local.os_deployment_name

    env = [for k, v in local.os_environment_variables : {
      name  = k
      value = v
    }]

    # liveness_probe = {
    #   initial_delay_seconds = 240

    #   http_get = {
    #     host   = module.opensearch_service.service.metadata.0.name
    #     path   = "/"
    #     port   = var.opensearch.port
    #     scheme = "HTTP"
    #   }
    # }

    ports = [{
      container_port = var.opensearch.port
      }, {
      container_port = 9600
    }]

    resource_limits = {
      cpu    = var.opensearch.cpu
      memory = var.opensearch.memory
    }

    resource_requests = {
      cpu    = var.opensearch.cpu
      memory = var.opensearch.memory
    }

    volume_mounts = [{
      name       = "os-data-volume"
      mount_path = "/usr/share/opensearch/data"
      read_only  = false
    }]
  }]

  labels = {
    app = local.os_deployment_name
  }

  volumes = [{
    name = "os-data-volume"
    persistent_volume_claim = {
      claim_name = module.opensearch_data_volume.volume.metadata.0.name
      read_only  = false
    }
  }]
}
