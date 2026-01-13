resource "azurerm_service_plan" "sp_dotnet_app" {
  name                = "sp_dotnet_app"
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location
  os_type             = "Linux"
  sku_name            = "P1v2"  
}

resource "azurerm_linux_web_app" "wa-main-dotnet" {
  name                = "Main WebApp Dotnet"
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_service_plan.sp_dotnet_app.location
  service_plan_id     = azurerm_service_plan.sp_dotnet_app.id

  site_config {}
}