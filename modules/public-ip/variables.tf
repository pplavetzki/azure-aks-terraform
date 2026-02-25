variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "domain_name_label" {
  description = "DNS label — results in <label>.<region>.cloudapp.azure.com"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
