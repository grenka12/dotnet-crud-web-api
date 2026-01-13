resource "azurerm_service_plan" "sp_dotnet_app" {
  name                = "sp_dotnet_app"
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_resource_group.rg_main.location
  os_type             = "Linux"
  sku_name            = "B1"  
}

resource "azurerm_linux_web_app" "app" {
  name                = "dotnet-crud-main"
  resource_group_name = azurerm_resource_group.rg_main.name
  location            = azurerm_service_plan.sp_dotnet_app.location
  service_plan_id     = azurerm_service_plan.sp_dotnet_app.id

site_config {
  application_stack {
    docker_image_name   = "${azurerm_container_registry.acr_main.login_server}/dotnet-crud-api:latest"
    docker_registry_url = "https://${azurerm_container_registry.acr_main.login_server}"
  }
}


  app_settings = {
    WEBSITES_PORT = "8080"

    DOCKER_REGISTRY_SERVER_URL      = "https://${azurerm_container_registry.acr_main.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr_main.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr_main.admin_password

    ASPNETCORE_ENVIRONMENT = "Development"
  }
}
