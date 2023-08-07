variable "allocate_load_balancer_node_ports" {
  type    = bool
  default = true
}

variable "cluster_ip" {
  type    = string
  default = null
}

variable "cluster_ips" {
  type    = list(string)
  default = null
}

variable "external_ips" {
  type    = list(string)
  default = null
}

variable "external_name" {
  type    = string
  default = null
}

variable "external_traffic_policy" {
  type    = string
  default = null
}

variable "health_check_node_port" {
  type    = number
  default = null
}

variable "internal_traffic_policy" {
  type    = string
  default = null
}

variable "ip_families" {
  type    = list(string)
  default = null
}

variable "ip_family_policy" {
  type    = string
  default = null
}

variable "load_balancer_class" {
  type    = string
  default = null
}

variable "load_balancer_ip" {
  type    = string
  default = null
}

variable "load_balancer_source_ranges" {
  type    = set(string)
  default = null
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "ports" {
  type = list(object({
    app_protocol = optional(string)
    name         = optional(string)
    node_port    = optional(number)
    port         = number
    protocol     = optional(string)
    target_port  = optional(number)
  }))
}

variable "publish_not_ready_addresses" {
  type    = bool
  default = false
}

variable "selector" {
  type = map(string)
}

variable "session_affinity" {
  type    = string
  default = null
}

variable "type" {
  type = string
}
