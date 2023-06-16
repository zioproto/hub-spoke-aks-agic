module "networkspoke1" {
  source  = "Azure/subnets/azurerm"
  version = "1.0.0"
  providers = {
    azurerm = azurerm.spoke1
  }

  resource_group_name = azurerm_resource_group.spoke1.name
  subnets = {
    subnet0 = {
      address_prefixes = ["10.52.0.0/24"]
    }
  }
  virtual_network_address_space = ["10.52.0.0/16"]
  virtual_network_location      = var.region
  virtual_network_name          = "spoke1"
}

# Create a network for the HUB with a subnet for the application gateway
module "networkhub" {
  source  = "Azure/subnets/azurerm"
  version = "1.0.0"
  providers = {
    azurerm = azurerm.hub
  }

  resource_group_name = azurerm_resource_group.hub.name
  subnets = {
    subnet0 = {
      address_prefixes = ["10.0.0.0/24"]
    }
  }
  virtual_network_address_space = ["10.0.0.0/16"]
  virtual_network_location      = var.region
  virtual_network_name          = "hub"
}

#Vnet peering for networkhub with networkspoke1
resource "azurerm_virtual_network_peering" "hub2spoke1" {
  provider                  = azurerm.hub
  name                      = "hub"
  resource_group_name       = azurerm_resource_group.hub.name
  virtual_network_name      = "hub"
  remote_virtual_network_id = module.networkspoke1.vnet_id
}

#Vnet peering for networkspoke1 with networkhub
resource "azurerm_virtual_network_peering" "spoke12hub" {
  provider                  = azurerm.spoke1
  name                      = "networkspoke1"
  resource_group_name       = azurerm_resource_group.spoke1.name
  virtual_network_name      = "spoke1"
  remote_virtual_network_id = module.networkhub.vnet_id
}

