module "mosquitto_namespace" {
  source = "../_modules/namespace"
  name   = var.namespace

  labels = {
    app = local.mosquitto_deployment_name
  }
}

module "mosquitto_config" {
  source    = "../_modules/config-map"
  name      = local.mosquitto_configuration_name
  namespace = module.mosquitto_namespace.namespace.metadata.0.name

  config_data = {
    "mosquitto.conf" = file("${path.module}/mosquitto.conf")
  }
}

module "mosquitto_password" {
  source    = "../_modules/config-map"
  name      = local.mosquitto_password_name
  namespace = module.mosquitto_namespace.namespace.metadata.0.name

  config_data = {
    "password.txt" = file("${path.module}/password.txt")
  }
}

module "mosquitto_data_volume" {
  source    = "../_modules/volume"
  name      = local.mosquitto_volume_name
  namespace = module.mosquitto_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "mosquitto_log_volume" {
  source    = "../_modules/volume"
  name      = local.mosquitto_log_volumne_name
  namespace = module.mosquitto_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "mosquitto_service" {
  source    = "../_modules/service"
  name      = local.mosquitto_service_name
  namespace = module.mosquitto_namespace.namespace.metadata.0.name

  type = "LoadBalancer"

  ports = [{
    port        = 1883
    target_port = 1883
  }]

  selector = {
    app = local.mosquitto_deployment_name
  }
}

module "mosquitto" {
  source    = "../_modules/deployment"
  name      = local.mosquitto_deployment_name
  namespace = module.mosquitto_namespace.namespace.metadata.0.name

  containers = [{
    name  = local.mosquitto_deployment_name
    image = "eclipse-mosquitto"

    env = [for k, v in local.mosquitto_environment_variables : {
      name  = k
      value = v
    }]

    liveness_probe = {
      exec = {
        command = ["/bin/true"]
      }
    }

    ports = [{
      container_port = 1883
      }, {
      container_port = 9001
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
      name       = "config-volume"
      mount_path = "/mosquitto/config/mosquitto.conf"
      sub_path   = "mosquitto.conf"
      read_only  = false
      }, {
      name       = "data-volume"
      mount_path = "/mosquitto/data"
      read_only  = false
      }, {
      name       = "log-volume"
      mount_path = "/mosquitto/log"
      read_only  = false
      }, {
      name       = "passwd-volume"
      mount_path = "/mosquitto/config/password.txt"
      sub_path   = "password.txt"
      read_only  = false
    }]
  }]

  volumes = [{
    name = "config-volume"
    config_map = {
      name = local.mosquitto_configuration_name
    }
    }, {
    name = "data-volume"
    persistent_volume_claim = {
      claim_name = local.mosquitto_volume_name
      read_only  = false
    }
    }, {
    name = "log-volume"
    persistent_volume_claim = {
      claim_name = local.mosquitto_log_volumne_name
      read_only  = false
    }
    }, {
    name = "passwd-volume"
    config_map = {
      name = local.mosquitto_password_name
    }
  }]

  labels = {
    app = local.mosquitto_deployment_name
  }
}
