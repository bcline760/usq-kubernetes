variable "app_key" {
  type      = string
  sensitive = true
}

variable "database" {
  type = object({
    name              = string
    connection_string = string
  })
  sensitive = true
}

variable "name" {
  type    = string
  default = "notary"
}

variable "namespace" {
  type    = string
  default = "usq-notary"
}

variable "service_principal" {
  type = object({
    client_id     = string
    client_secret = string
    domain        = string
    tenant_id     = string
  })
  sensitive = true
}

variable "usq_key_vault" {
  type = object({
    name                = string
    resource_group_name = string
    secret_name         = string
  })
}
