module "homeassistant_namespace" {
  source = "../_modules/namespace"
  name   = var.namespace

  labels = {
    app = local.homeassistant_deployment_name
  }
}

module "homeassistant_data_volume" {
  source    = "../_modules/volume"
  name      = local.homeassistant_volume_name
  namespace = module.homeassistant_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "homeassistant_service" {
  source    = "../_modules/service"
  name      = local.homeassistant_service_name
  namespace = module.homeassistant_namespace.namespace.metadata.0.name

  type = "ClusterIP"

  ports = [{
    port        = 80
    target_port = 8083
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
          port_number = 80
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
    image = "homeassistant/homeassistant:lts-jdk11"

    env = [for k, v in local.homeassistant_environment_variables : {
      name  = k
      value = v
    }]

    ports = [{
      container_port = 8083
    }]

    resource_limits = {
      cpu    = "500m"
      memory = "1Gi"
    }

    resource_requests = {
      cpu    = "500m"
      memory = "1Gi"
    }

    volume_mounts = [{
      name       = "data-volume"
      mount_path = "/var/homeassistant_home"
    }]
  }]

  volumes = [{
    name = "data-volume"
    persistent_volume_claim = {
      claim_name = local.homeassistant_volume_name
      read_only  = false
    }
  }]

  labels = {
    app = local.homeassistant_deployment_name
  }
}
