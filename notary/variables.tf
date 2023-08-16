variable "mongo_credentials" {
  type = object({
    admin_account  = string
    admin_password = string
  })
  sensitive = true
}

variable "namespace" {
  type = string
}

variable "name" {
  type    = string
  default = "usq-notary"
}
