
module "notary_namespace" {
  source = "../_modules/namespace"
  name   = var.namespace

  labels = {
    app = local.notary_deployment_name
  }
}

module "notary_service" {
  source    = "../_modules/service"
  name      = local.notary_service_name
  namespace = module.notary_namespace.namespace.metadata.0.name

  type = "ClusterIP"

  ports = [{
    name        = "http"
    port        = 80
    target_port = 80
    }, {
    name        = "https"
    port        = 443
    target_port = 443
  }]

  selector = {
    app = local.notary_deployment_name
  }
}

resource "kubernetes_secret_v1" "notary_tls_key" {
  metadata {
    name      = local.notary_tls_name
    namespace = module.notary_namespace.namespace.metadata.0.name
  }

  type = "Opaque"

  data = {
    "tls.crt" = data.azurerm_key_vault_certificate_data.notary_tls_certificate.pem,
    "tls.key" = data.azurerm_key_vault_certificate_data.notary_tls_certificate.key
  }
}

module "notary_ingress" {
  source    = "../_modules/ingress"
  name      = local.notary_ingress_name
  namespace = module.notary_namespace.namespace.metadata.0.name

  annotations = {
    "ingress.kubernetes.io/ssl-redirect"           = "true"
    "ingress.kubernetes.io/custom-request-headers" = "X-Forwarded-Proto: HTTPS"
  }

  rules = [{
    host = "notary.unionsquared.lan"
    paths = [{
      path = "/"
      backend = {
        service = {
          name        = module.notary_service.service.metadata.0.name
          port_number = 80
        }
      }
    }]
  }]

  tls = {
    hosts       = ["notary.unionsquared.lan"]
    secret_name = local.notary_tls_name
  }
}

module "notary" {
  source = "../_modules/deployment"

  name      = local.notary_deployment_name
  namespace = module.notary_namespace.namespace.metadata.0.name

  containers = [{
    name  = local.notary_deployment_name
    image = "urbanarcher/notary-web:1.0.17"

    env = [for k, v in local.notary_environment_variables : {
      name  = k
      value = v
    }]

    liveness_probe = {
      exec = {
        command = ["/bin/true"]
      }
    }

    ports = [{
      container_port = 80
      }, {
      container_port = 443
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
    app = local.notary_deployment_name
  }
}
