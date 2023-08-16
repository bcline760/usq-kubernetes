module "elastic_namespace" {
  source = "../_modules/namespace"
  name   = var.namespace

  labels = {
    app = local.es_deployment_name
  }
}

module "elastic_search_data_volume" {
  source    = "../_modules/volume"
  name      = local.es_volume_name
  namespace = module.elastic_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "elastic_search_service" {
  source    = "../_modules/service"
  name      = local.es_service_name
  namespace = module.elastic_namespace.namespace.metadata.0.name

  type = "ClusterIP"

  ports = [{
    port        = 80
    target_port = 9200
  }]

  selector = {
    app = local.es_deployment_name
  }
}

module "elastic_search" {
  source    = "../_modules/deployment"
  name      = local.es_deployment_name
  namespace = module.elastic_namespace.namespace.metadata.0.name

  labels = {
    app = local.es_deployment_name
  }

  containers = [{
    name  = local.es_deployment_name
    image = "docker.elastic.co/elasticsearch/elasticsearch:8.9.0"

    env = [for k, v in local.es_environment_variables : {
      name  = k
      value = v
    }]

    ports = [{
      container_port = 9200
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
      mount_path = "/usr/share/elasticsearch/data"
    }]
  }]

  volumes = [{
    name = "data-volume"
    persistent_volume_claim = {
      claim_name = module.elastic_search_data_volume.volume.metadata.0.name
      read_only  = false
    }
  }]
}

module "elastic_search_ingress" {
  source    = "../_modules/ingress"
  name      = local.es_ingress_name
  namespace = module.elastic_namespace.namespace.metadata.0.name

  annotations = {
    "ingress.kubernetes.io/ssl-redirect" = "false"
  }

  rules = [{
    host = "elastic-search.unionsquared.lan"
    paths = [{
      path = "/"
      backend = {
        service = {
          name        = module.elastic_search_service.service.metadata.0.name
          port_number = 80
        }
      }
    }]
  }]
}
