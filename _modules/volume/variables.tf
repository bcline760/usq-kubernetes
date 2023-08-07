variable "access_modes" {
  type    = list(string)
  default = null
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "storage_class_name" {
  type    = string
  default = null
}

variable "resource_limits" {
  type    = map(string)
  default = null
}
variable "resource_requests" {
  type    = map(string)
  default = null
}

variable "volume_name" {
  type    = string
  default = null
}

variable "wait_until_bound" {
  type        = bool
  default     = true
  description = "(Optional) Whether to wait for the claim to reach Bound state (to find volume in which to claim the space). Set this to `false` if your volume uses WaitForFirstConsumer. Defaults to `true`"
}
