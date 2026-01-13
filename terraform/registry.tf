resource "azurerm_container_registry" "acr_main" {
  name                = "acr-dotnetcrud-bestrong"
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location

  sku           = "Basic"
  admin_enabled = true
}
