# Domain controller resources

resource "azurerm_public_ip" "dc" {
  name                = "${local.dc_prefix}-public-ip"
  location            = azurerm_resource_group.ad.location
  resource_group_name = azurerm_resource_group.ad.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "dc" {
  name                = "${local.dc_prefix}-nic"
  location            = azurerm_resource_group.ad.location
  resource_group_name = azurerm_resource_group.ad.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.dc.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.dc.address_prefix, 4)
    public_ip_address_id          = azurerm_public_ip.dc.id
  }
}

resource "azurerm_network_interface_security_group_association" "dc" {
  network_interface_id      = azurerm_network_interface.dc.id
  network_security_group_id = azurerm_network_security_group.ad.id
}

resource "azurerm_windows_virtual_machine" "dc" {
  name                  = local.dc_prefix
  location              = azurerm_resource_group.ad.location
  resource_group_name   = azurerm_resource_group.ad.name
  admin_username        = var.admin_user
  admin_password        = random_password.ad.result
  computer_name         = var.dc_name
  network_interface_ids = [azurerm_network_interface.dc.id]
  size                  = var.dc_size
  timezone              = var.timezone

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.dc_image_sku
    version   = var.dc_image_version
  }

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }
}

# Created as a local so we can pass it to the replace function below
locals {
  dc_promote = <<-END
    powershell "
    $Password = ConvertTo-SecureString -AsPlainText -String '${random_password.ad.result}' -Force;
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools;
    Install-ADDSForest -DomainName '${var.ad_domain}.${var.dns_domain_name}' -SafeModeAdministratorPassword $Password -InstallDns -Force
    "
    END
}

resource "azurerm_virtual_machine_extension" "dc_promote" {
  name                 = "dc_promote"
  virtual_machine_id   = azurerm_windows_virtual_machine.dc.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = jsonencode(
    {
      commandToExecute = replace(local.dc_promote, "\n", " ")
    }
  )
}
