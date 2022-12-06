# DNS resources

# Only required if you want to create a custom domain name for AAD
resource "azurerm_dns_txt_record" "verification" {
  name                = var.ad_domain
  zone_name           = var.dns_domain_name
  resource_group_name = var.dns_rg_name
  ttl                 = 3600
  record {
    value = var.dns_verification
  }
}

resource "azurerm_dns_a_record" "dc_public" {
  name                = "${var.dc_name}.${var.ad_domain}"
  zone_name           = var.dns_domain_name
  resource_group_name = var.dns_rg_name
  ttl                 = 300
  records             = [azurerm_public_ip.dc.ip_address]
}

resource "azurerm_dns_a_record" "member_public" {
  count               = var.member_count
  name                = "${var.member_name}${format("%02d", count.index + 1)}.${var.ad_domain}"
  zone_name           = var.dns_domain_name
  resource_group_name = var.dns_rg_name
  ttl                 = 300
  records             = [azurerm_public_ip.member[count.index].ip_address]
}
