module "notary_namespace" {
  source = "../_modules/namespace"
  name   = var.namespace
}

module "notary_mongo_volume" {
  source    = "../_modules/volume"
  name      = local.notary_mongo_volume_name
  namespace = module.notary_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "notary_mongo_volume" {
  source    = "../_modules/volume"
  name      = local.notary_mongo_volume_name
  namespace = module.notary_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "notary_app" {
  source    = "../_modules/deployment"
  name      = local.notary_deployment_name
  namespace = module.notary_namespace.namespace.metadata.0.name

  containers = [
    {
      name  = local.notary_mongo_container_name
      image = "mongo:latest"
      port  = 27017

      env = [for k, v in local.mongo_environment_variables : {
        name  = k
        value = v
      }]

      volume_mounts = [{
        name       = "data-volume"
        mount_path = "/data/db"
      }]
    },
    {
      name  = local.notary_deployment_name
      image = ""

      env = [for k, v in local.notary_environment_variables : {
        name  = k
        value = v
      }]
    }
  ]

  volumes = [{
    name = "data-volume"
    persistent_volume_claim = {
      claim_name = module.notary_mongo_volume.volume.metadata.0.name
      read_only  = false
    }
  }]
}
