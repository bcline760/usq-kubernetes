module "homeassistant_namespace" {
  source = "../_modules/namespace"
  name   = var.namespace

  labels = {
    app = local.homeassistant_deployment_name
  }
}

module "homeassistant_service" {
  source    = "../_modules/service"
  name      = local.homeassistant_service_name
  namespace = module.homeassistant_namespace.namespace.metadata.0.name

  type = "ClusterIP"

  ports = [{
    port        = 8123
    target_port = 8123
  }]

  selector = {
    app = local.homeassistant_deployment_name
  }
}

module "homeassistant_ingress" {
  source    = "../_modules/ingress"
  name      = local.homeassistant_ingress_name
  namespace = module.homeassistant_namespace.namespace.metadata.0.name

  annotations = {
    "ingress.kubernetes.io/ssl-redirect" = "false"
  }

  rules = [{
    host = "homeassistant.unionsquared.lan"
    paths = [{
      path = "/"
      backend = {
        service = {
          name        = module.homeassistant_service.service.metadata.0.name
          port_number = 8123
        }
      }
    }]
  }]
}

module "homeassistant" {
  source    = "../_modules/deployment"
  name      = local.homeassistant_deployment_name
  namespace = module.homeassistant_namespace.namespace.metadata.0.name

  containers = [{
    name  = local.homeassistant_deployment_name
    image = "homeassistant/home-assistant:latest"

    env = [for k, v in local.homeassistant_environment_variables : {
      name  = k
      value = v
    }]

    ports = [{
      container_port = 8123
    }]

    resource_limits = {
      cpu    = "500m"
      memory = "1Gi"
    }

    resource_requests = {
      cpu    = "500m"
      memory = "1Gi"
    }
  }]

  labels = {
    app = local.homeassistant_deployment_name
  }
}
