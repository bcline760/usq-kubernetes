module "mongo_namespace" {
  source = "../_modules/namespace"
  name   = var.namespace

  labels = {
    app = local.mongo_deployment_name
  }
}

module "mongo_data_volume" {
  source    = "../_modules/volume"
  name      = local.mongo_volume_name
  namespace = module.mongo_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = var.database_size
  }
}

module "mongo_service" {
  source    = "../_modules/service"
  name      = local.mongo_service_name
  namespace = module.mongo_namespace.namespace.metadata.0.name

  type = "LoadBalancer"

  ports = [{
    port        = var.mongo_port
    target_port = var.mongo_port
  }]

  selector = {
    app = local.mongo_deployment_name
  }
}

module "mongo" {
  source = "../_modules/deployment"

  name      = local.mongo_deployment_name
  namespace = module.mongo_namespace.namespace.metadata.0.name

  containers = [{
    name  = local.mongo_deployment_name
    image = "mongo"

    env = [for k, v in local.mongo_environment_variables : {
      name  = k
      value = v
    }]

    liveness_probe = {
      exec = {
        command = ["/bin/true"]
      }
    }

    ports = [{
      container_port = var.mongo_port
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
      mount_path = "/data/db"
      name       = "db-volume"
      read_only  = false
    }]
  }]

  labels = {
    app = local.mongo_deployment_name
  }

  volumes = [{
    name = "db-volume"
    persistent_volume_claim = {
      claim_name = local.mongo_volume_name
      read_only  = false
    }
  }]
}
