variable "azure-subscription" {
  description = "Azure subscription id"
}

variable "azure-tenant" {
  description = "Azure tenant id"
}

variable "azure-resource-group" {
  description = "Azure resource group name"
}

variable "azure-location" {
  description = "Azure location"
}

variable "azure-net-name" {
  description = "Azure virtual net name"
}

variable "azure-address-space" {
  description = "Azure address space"
  type        = list(string)
}

variable "azure-dns-servers" {
  description = "Azure DNS servers"
  type        = list(string)
}

variable "azure-subnet-name" {
  description = "Azure subnet name"
}

variable "azure-subnet-prefixes" {
  description = "Azure subnet prefixes"
  type        = list(string)
}
