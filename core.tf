# Core resources shared across servers

resource "azurerm_resource_group" "ad" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "ad" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.ad.location
  resource_group_name = azurerm_resource_group.ad.name
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "dc" {
  name                 = "dc"
  resource_group_name  = azurerm_resource_group.ad.name
  virtual_network_name = azurerm_virtual_network.ad.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.ad.address_space[0], 8, 0)
}

resource "azurerm_subnet" "member" {
  name                 = "member"
  resource_group_name  = azurerm_resource_group.ad.name
  virtual_network_name = azurerm_virtual_network.ad.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.ad.address_space[0], 8, 1)
}

resource "azurerm_network_security_group" "ad" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.ad.location
  resource_group_name = azurerm_resource_group.ad.name

  security_rule {
    name                       = "rdp"
    priority                   = 100
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefixes    = var.admin_cidrs
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = 3389
    access                     = "Allow"
  }
}

resource "random_password" "ad" {
  length      = 30
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}
