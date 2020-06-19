terraform {
  backend "azurerm" {
    resource_group_name = "terraformstorage"
    storage_account_name = "terraformstorage7376"
    container_name       = "terraform"
    key                  = "ij6/631u5rGQVrTKO0DQpdS2Krk6KUHLbCT8fkkr0ljj6RlpzwrBmrPnHUZ3PcG9Y2MvHwjZH26jinr0FcV3Mw=="
  }
}


provider "azurerm"{
    features {}
    subscription_id = var.subscription_id
    client_id = var.client_id
    tenant_id = var.tenant_id
}

resource "azurerm_resource_group" "rg"{
    name = "Pls-erg"
    location = var.location
}

resource "azurerm_virtual_network" "rg"{
    name = "pls-vnet"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = [var.address_space]
}

resource "azurerm_subnet" "rg"{
  name                 = "pls-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg.name
  address_prefix       = var.address_prefix
  enforce_private_link_service_network_policies = true
}

resource "azurerm_public_ip" "rg" {
  name                = "pls-ip"
  sku                 = "Standard"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "rg" {
  name                = "pls-lb"
  sku                 = "Standard"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = azurerm_public_ip.rg.name
    public_ip_address_id = azurerm_public_ip.rg.id
  }
}


resource "azurerm_private_link_service" "rg" {
  name                = "pls-privatelink"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.rg.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name                       = "primary"
    private_ip_address         = var.primary_private_ip_address
    private_ip_address_version = "IPv4"
    subnet_id                  = azurerm_subnet.rg.id
    primary                    = true
  }

  nat_ip_configuration {
    name                       = "secondary"
    private_ip_address         = var.secondary_private_ip_address
    private_ip_address_version = "IPv4"
    subnet_id                  = azurerm_subnet.rg.id
    primary                    = false
  }
}