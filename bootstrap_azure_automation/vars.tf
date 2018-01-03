variable "resourcegroup_name" {
  default = "HOMES"
}
variable "vm_name" {
  description = "What is the name of the server you want to create"
  default = "ashcazd-hms-002"
}
variable "location" {
  default = "East US"
}
variable "admin_username" {
  default = "devops"
}
variable "admin_password" {
  default = "---------"
}
variable "dsc_key" {
  default = "[your_azure_automation_access_key]"
}
variable "dsc_endpoint" {
  default = "[azure_automation_url]"
}
