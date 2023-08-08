variable "kibana_service_account" {
  type = object({
    login    = string
    password = string
  })
  sensitive = true
}

variable "name" {
  type    = string
  default = "usq-search"
}

variable "namespace" {
  type = string
}