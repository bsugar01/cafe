provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Generate unique suffix for storage account name
resource "random_id" "unique" {
  byte_length = 4
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "cafe-website-rg"
  location = "UK South"
}

# Create a storage account with static website enabled
resource "azurerm_storage_account" "static_site" {
  name                     = "cafeweb${random_id.unique.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  tags = {
    environment = "production"
  }
}

# Output the website URL
output "static_website_url" {
  value       = azurerm_storage_account.static_site.primary_web_endpoint
  description = "URL to access your deployed static website"
}

# Declare input variables
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
