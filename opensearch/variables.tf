variable "opensearch" {
  type = object({
    name   = string
    cpu    = string
    host   = string
    memory = string
    port   = number
    volume = object({
      size = string
    })
  })
}


variable "name" {
  type    = string
  default = "usq-search"
}

variable "namespace" {
  type = string
}
