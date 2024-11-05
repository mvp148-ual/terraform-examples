resource "azurerm_resource_group" "tf-resource-group" {
  name     = var.azure-resource-group
  location = var.azure-location
}
