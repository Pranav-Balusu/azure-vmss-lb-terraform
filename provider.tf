terraform {
  required_version = ">=1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.8.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "tfstatebackendstorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

#create resource group
resource "azurerm_resource_group" "rg" {
  name     = "vmss-lb-rg"
  location = "eastus"
}

#example output
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}