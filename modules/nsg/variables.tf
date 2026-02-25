variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "allowed_ip_ranges" {
  description = "Set of IP ranges to allow inbound on 80/443"
  type        = set(string)
}

variable "subnet_ids" {
  description = "Map of subnet IDs to associate the NSG with"
  type        = map(string)
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
