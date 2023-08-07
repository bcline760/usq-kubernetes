locals {
  policy_types = [
    var.ports.egress != null ? "Egress" : "",
    var.ports.ingress != null ? "Ingress" : ""
  ]
}
