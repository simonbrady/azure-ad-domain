output "admin_password" {
  value = random_password.ad.result
}

output "dc_public_ip" {
  value = azurerm_public_ip.dc.ip_address
}

output "member_public_ips" {
  value = azurerm_public_ip.member[*].ip_address
}
