# Create a Public IP with Terraform as:
# az network public-ip create -n myPublicIp -g myResourceGroup --allocation-method Static --sku Standard

resource "azurerm_public_ip" "publicip" {
  provider            = azurerm.hub
  name                = "myPublicIp"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create an Application Gateway with Terraform as:
# az network application-gateway create -n myApplicationGateway -l eastus -g myResourceGroup --sku Standard_v2 --public-ip-address myPublicIp --vnet-name myVnet --subnet mySubnet --priority 100

resource "azurerm_application_gateway" "gateway" {
  provider            = azurerm.hub
  name                = "myApplicationGateway"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name      = "myApplicationGatewayIpConfig"
    subnet_id = lookup(module.networkhub.vnet_subnets_name_id, "subnet0")
  }
  frontend_port {
    name = "hub-feport"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "hub-feip"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
  http_listener {
    name                           = "hub-httplistener"
    frontend_ip_configuration_name = "hub-feip"
    frontend_port_name             = "hub-feport"
    protocol                       = "Http"
  }

  backend_address_pool {
    name = "hub-bepool"
  }

  backend_http_settings {
    name                  = "hub-behttpsetting"
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }


  request_routing_rule {
    name                       = "hub-rule"
    rule_type                  = "Basic"
    http_listener_name         = "hub-httplistener"
    backend_address_pool_name  = "hub-bepool"
    backend_http_settings_name = "hub-behttpsetting"
    priority                   = 20
  }
}
