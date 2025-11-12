# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "2213e8b1-dbc7-4d54-8aff-b5e315df5e5b"
    client_id       = "6c183a1b-5fc0-4c29-b0e5-945c639b2273"
    client_secret   = ".Ma8Q~XwCC3KVuYNdVlVauStgB2BLxTaEb~FAba0"
    tenant_id       = "84f1e4ea-8554-43e1-8709-f0b8589ea118"
    features {}
    skip_provider_registration = true
    }

resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name
    location = var.location
    
}

resource "azurerm_virtual_network" "vnet" {
    name                 = "${var.prefix}-vnet"
    resource_group_name  = azurerm_resource_group.rg.name
    location             = azurerm_resource_group.rg.location
    address_space        = var.vnet_cidr
}

# Subnets 
resource "azurerm_subnet" "web" {
    name                 = "${var.prefix}-web-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [var.subnet_cidrs["web"]]
}

resource "azurerm_subnet" "app" {
    name                 = "${var.prefix}-app-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [var.subnet_cidrs["app"]]

    delegation {
        name = "Microsoft.Web.serverFarms"
        service_delegation {
            name = "Microsoft.Web/serverFarms"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
    }
}

resource "azurerm_subnet" "db" {
    name                 = "${var.prefix}-db-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [var.subnet_cidrs["db"]]
}