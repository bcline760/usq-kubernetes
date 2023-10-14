variable "annotations" {
  type     = map(string)
  nullable = true
  default  = null
}

variable "binary_config_data" {
  type     = map(string)
  nullable = true
  default  = null
}

variable "config_data" {
  type     = map(string)
  nullable = true
  default  = null
}

variable "immutable" {
  type    = bool
  default = false
}

variable "labels" {
  type     = map(string)
  default  = null
  nullable = true
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}
