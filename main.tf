provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "random_id" "unique" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = "cafe-website-rg"
  location = "UK South"
}

resource "azurerm_storage_account" "static_site" {
  name                     = "cafeweb${random_id.unique.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = "production"
  }
}

resource "azurerm_storage_account_static_website" "website" {
  storage_account_id = azurerm_storage_account.static_site.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

output "static_website_url" {
  value       = azurerm_storage_account_static_website.website.primary_web_endpoint
  description = "URL to access your deployed static website"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
