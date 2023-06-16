# AGIC Identity needs atleast has 'Contributor' access to Application Gateway and 'Reader' access to Application Gateway's Resource Group
# Create an Azure Role
resource "azurerm_role_assignment" "contributor" {
  provider             = azurerm.hub
  scope                = azurerm_application_gateway.gateway.id
  role_definition_name = "Contributor"
  principal_id         = module.aks.ingress_application_gateway.ingress_application_gateway_identity[0].object_id
}

resource "azurerm_role_assignment" "reader" {
  provider             = azurerm.hub
  scope                = azurerm_resource_group.hub.id
  role_definition_name = "Reader"
  principal_id         = module.aks.ingress_application_gateway.ingress_application_gateway_identity[0].object_id
}