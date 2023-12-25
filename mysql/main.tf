module "mysql_namespace" {
  source = "../_modules/namespace"
  name   = var.namespace

  labels = {
    app = local.mysql_deployment_name
  }
}

module "mysql_database_volume" {
  source    = "../_modules/volume"
  name      = local.mysql_volume_name
  namespace = module.mysql_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = var.database_size
  }
}

module "mysql_service" {
  source    = "../_modules/service"
  name      = local.mysql_service_name
  namespace = module.mysql_namespace.namespace.metadata.0.name

  type = "LoadBalancer"
  ports = [{
    port        = var.mysql_port
    target_port = var.mysql_port
  }]

  selector = {
    app = local.mysql_deployment_name
  }
}


module "mysql" {
  source = "../_modules/deployment"

  name      = local.mysql_deployment_name
  namespace = module.mysql_namespace.namespace.metadata.0.name

  containers = [{
    name  = local.mysql_deployment_name
    image = "mysql"

    env = [for k, v in local.mysql_environment_variables : {
      name  = k
      value = v
    }]

    liveness_probe = {
      exec = {
        command = ["/bin/true"]
      }
    }

    ports = [{
      container_port = var.mysql_port
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
      mount_path = "/data/mysql_db"
      name       = "db-volume"
      read_only  = false
    }]
  }]

  labels = {
    app = local.mysql_deployment_name
  }

  volumes = [{
    name = "db-volume"
    persistent_volume_claim = {
      claim_name = local.mysql_volume_name
      read_only  = false
    }
  }]
}
