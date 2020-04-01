# Member server resources

resource "azurerm_public_ip" "member" {
  count               = var.member_count
  name                = "${local.member_prefix}${format("%02d", count.index + 1)}-public-ip"
  location            = azurerm_resource_group.ad.location
  resource_group_name = azurerm_resource_group.ad.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "member" {
  # Requires DNS service to be up and running on the DC
  depends_on          = [azurerm_virtual_machine_extension.dc_promote]
  count               = var.member_count
  name                = "${local.member_prefix}${format("%02d", count.index + 1)}-nic"
  location            = azurerm_resource_group.ad.location
  resource_group_name = azurerm_resource_group.ad.name
  dns_servers         = [azurerm_network_interface.dc.private_ip_address]

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.member.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.member[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "member" {
  count                     = var.member_count
  network_interface_id      = azurerm_network_interface.member[count.index].id
  network_security_group_id = azurerm_network_security_group.ad.id
}

resource "azurerm_windows_virtual_machine" "member" {
  count                 = var.member_count
  name                  = "${local.member_prefix}${format("%02d", count.index + 1)}"
  location              = azurerm_resource_group.ad.location
  resource_group_name   = azurerm_resource_group.ad.name
  admin_username        = var.admin_user
  admin_password        = random_password.ad.result
  computer_name         = "${var.member_name}${format("%02d", count.index + 1)}"
  network_interface_ids = [azurerm_network_interface.member[count.index].id]
  size                  = var.member_size
  timezone              = var.timezone

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.member_image_sku
    version   = var.member_image_version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
}

resource "azurerm_virtual_machine_extension" "join_domain" {
  count                = var.member_count
  name                 = "join_domain"
  virtual_machine_id   = azurerm_windows_virtual_machine.member[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  settings = jsonencode(
    {
      Name    = "${var.ad_domain}.${var.dns_domain_name}"
      User    = "${var.ad_domain}\\${var.admin_user}"
      Options = 3
      OUPath  = ""
      Restart = true
    }
  )
  protected_settings = jsonencode(
    {
      Password = random_password.ad.result
    }
  )
}
