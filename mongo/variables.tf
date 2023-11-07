variable "admin_credentials" {
  type = object({
    login    = string
    password = string
  })
}

variable "database_size" {
  type    = string
  default = "2Gi"
}

variable "mongo_port" {
  type    = number
  default = 27017
}

variable "name" {
  type    = string
  default = "mongo-instance"
}

variable "namespace" {
  type    = string
  default = "usq-mongo"
}
