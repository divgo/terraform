variable "aws_region" {
  default	= "us-east-1"
}
variable "aws_access_key" {
  default = "your_access_key"
}
variable "aws_secret_key" {
  default = "your_access_secret"
}
variable "site_name" {
  description = "The full DNS domain for the site."
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}
