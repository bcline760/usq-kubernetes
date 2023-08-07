variable "es_superuser_password" {
  type      = string
  sensitive = true
}

variable "name" {
  type    = string
  default = "usq-search"
}
