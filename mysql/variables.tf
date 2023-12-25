variable "admin_password" {
  type      = string
  sensitive = true
}

variable "database_size" {
  type = string
}

variable "mysql_port" {
  type = number
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}
