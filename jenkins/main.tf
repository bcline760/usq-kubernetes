module "jenkins_namespace" {
  source = "../_modules/namespace"
  name   = var.namespace

  labels = {
    app = local.jenkins_deployment_name
  }
}

module "jenkins_data_volume" {
  source    = "../_modules/volume"
  name      = local.jenkins_volume_name
  namespace = module.jenkins_namespace.namespace.metadata.0.name

  access_modes       = ["ReadWriteOnce"]
  storage_class_name = "local-path"
  wait_until_bound   = false

  resource_requests = {
    storage = "2Gi"
  }
}

module "jenkins_service" {
  source    = "../_modules/service"
  name      = local.jenkins_service_name
  namespace = module.jenkins_namespace.namespace.metadata.0.name

  type = "ClusterIP"

  ports = [{
    port        = 80
    target_port = 8080
  }]

  selector = {
    app = local.jenkins_deployment_name
  }
}

module "jenkins_ingress" {
  source    = "../_modules/ingress"
  name      = local.jenkins_ingress_name
  namespace = module.jenkins_namespace.namespace.metadata.0.name

  annotations = {
    "ingress.kubernetes.io/ssl-redirect" = "false"
  }

  rules = [{
    host = "jenkins.unionsquared.lan"
    paths = [{
      path = "/"
      backend = {
        service = {
          name        = module.jenkins_service.service.metadata.0.name
          port_number = 80
        }
      }
    }]
  }]
}

module "jenkins" {
  source    = "../_modules/deployment"
  name      = local.jenkins_deployment_name
  namespace = module.jenkins_namespace.namespace.metadata.0.name

  containers = [{
    name              = local.jenkins_deployment_name
    image             = "jenkins/jenkins:lts-jdk11"
    image_pull_policy = "Always"

    env = [for k, v in local.jenkins_environment_variables : {
      name  = k
      value = v
    }]

    ports = [{
      container_port = 8080
      }, {
      container_port = 50000
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
      mount_path = "/var/jenkins_home"
    }]
  }]

  volumes = [{
    name = "data-volume"
    persistent_volume_claim = {
      claim_name = local.jenkins_volume_name
      read_only  = false
    }
  }]

  labels = {
    app = local.jenkins_deployment_name
  }
}
