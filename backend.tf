terraform {
  backend "azurerm" {
    resource_group_name = "terraform-backend-rg"
    storage_account_name = "tfstatebackendstorage"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

#resources to create backend infrastructure 
provider "azurerm" {
  features {
    
  }
}

resource "azurerm_resource_group" "backend_rg" {
  name     = "terraform-backend-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "backend_storage" {
  name = "tfstatebackendstorage"
  resource_group_name = "azurerm_resource_group.backend_rg.name"
  location = "azurerm_resource_group.backend_rg.location"
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backend_container" {
  name                  = "tfstate"
  storage_account_name  = "azurerm_storage_account.backend_storage.name"
  container_access_type = "private"
}

output "backend_storage_account_name" {
  value = azurerm_storage_account.backend_storage.name
}

output "backend_container_name" {
  value=azurerm_storage_container.backend_container.name
}

# after these, do these step 

# terraform init
# terraform fmt
# terraform validate
# terraform plan
# terraform apply -auto-approve

# once if the resources are created, enable the backend for state storage int provider.tf 
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "terraform-backend-rg"
#     storage_account_name = "tfstatebackendstorage"
#     container_name       = "tfstate"
#     key                  = "terraform.tfstate"
#   }
# }



# then reintialize 
# terraform init -migrate-state
