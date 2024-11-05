resource "azurerm_resource_group" "tf-resource-group" {
  name     = var.azure-resource-group
  location = var.azure-location
}

resource "azurerm_virtual_network" "tf-net" {
  name                = var.azure-net-name
  location            = azurerm_resource_group.tf-resource-group.location
  resource_group_name = azurerm_resource_group.tf-resource-group.name
  address_space       = var.azure-address-space
  dns_servers         = var.azure-dns-servers
}

resource "azurerm_subnet" "tf-subnet" {
  name                 = var.azure-subnet-name
  resource_group_name  = azurerm_resource_group.tf-resource-group.name
  virtual_network_name = azurerm_virtual_network.tf-net.name
  address_prefixes     = var.azure-subnet-prefixes
}
