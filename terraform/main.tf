provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "dotnet-backend"
    storage_account_name = "dnbackendtf"
    container_name       = "tfstate"
    key                  = "app.terraform.tfstate"
  }
}


resource "azurerm_resource_group" "rg_main" {
  name     = "dotnet-rg"
  location = "Poland Central"
}

te