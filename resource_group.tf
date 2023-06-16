# Hub Resource Group
resource "azurerm_resource_group" "hub" {
  provider = azurerm.hub
  name     = "hub-rg"
  location = var.region
}

# Spoke1 Resource Group
resource "azurerm_resource_group" "spoke1" {
  provider = azurerm.spoke1
  name     = "spoke1-rg"
  location = var.region
}