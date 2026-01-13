resource "azurerm_container_registry" "acr_main" {
  name                = "dotnetcrudacr"
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location

  sku           = "Basic"
  admin_enabled = true
}
