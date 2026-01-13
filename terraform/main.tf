provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_main" {
  name     = "dotnet-rg"
  location = "Poland Central"
}

resource "azurerm_service_plan" "sp_dotnet_app" {
  name                = "sp_dotnet_app"
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location
  os_type             = "Linux"
  sku_name            = "P1v2"  
}

resource "azurerm_linux_web_app" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_service_plan.rg_main.location
  service_plan_id     = azurerm_service_plan.sp_dotnet_app.id

  site_config {}
}