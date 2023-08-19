variable "elasticsearch" {
  type = object({
    host     = string
    username = string
    password = string
  })
  sensitive = true
}

variable "enterprise_search" {
  type = object({
    url = string
  })
}

variable "enterprise_search_encryption_keys" {
  type      = list(string)
  sensitive = true
}

variable "kibana" {
  type = object({
    external_url = string
    host         = string
  })
}

variable "name" {
  type    = string
  default = "usq-search"
}

variable "namespace" {
  type = string
}
