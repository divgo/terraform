# module definition for "dns_domain" {
variable "domain_parts" {
    type = "list"
}
variable "parts_count" {}

output "root_dns" {
    value = "${var.domain_parts[var.parts_count - 2]}.${var.domain_parts[var.parts_count - 1]}"
}