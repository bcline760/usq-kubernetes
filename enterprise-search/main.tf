module "enterprise_search_data_volume" {
  source    = "../_modules/volume"
  name      = local.entsearch_volume_name
  namespace = data.kubernetes_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "enterprise_search_service" {
  source    = "../_modules/service"
  name      = local.entsearch_service_name
  namespace = data.kubernetes_namespace.namespace.metadata.0.name

  type = "ClusterIP"

  ports = [{
    port        = 80
    target_port = 3002
  }]

  selector = {
    app = local.entsearch_deployment_name
  }
}

module "enterprise_search_ingress" {
  source    = "../_modules/ingress"
  name      = local.entsearch_ingress_name
  namespace = data.kubernetes_namespace.namespace.metadata.0.name

  annotations = {
    "ingress.kubernetes.io/ssl-redirect" = "false"
  }

  rules = [{
    host = "enterprise-search.unionsquared.lan"
    paths = [{
      path = "/"
      backend = {
        service = {
          name        = module.enterprise_search_service.service.metadata.0.name
          port_number = 80
        }
      }
    }]
  }]
}

module "enterprise_search" {
  source    = "../_modules/deployment"
  name      = local.entsearch_deployment_name
  namespace = data.kubernetes_namespace.namespace.metadata.0.name

  containers = [{
    name  = local.entsearch_deployment_name
    image = "docker.elastic.co/enterprise-search/enterprise-search:8.9.0"

    env = [for k, v in local.entsearch_environment_variables : {
      name  = k
      value = v
    }]

    ports = [{
      container_port = 3002
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
      mount_path = "/usr/share/enterprise-search/data"
    }]
  }]

  labels = {
    app = local.entsearch_deployment_name
  }

  volumes = [{
    name = "data-volume"
    persistent_volume_claim = {
      claim_name = module.enterprise_search_data_volume.volume.metadata.0.name
      read_only  = false
    }
  }]

}
