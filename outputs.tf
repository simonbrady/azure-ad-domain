output "admin_password" {
  value = random_string.password.result
}

output "dc_dns_name" {
  value = azurerm_dns_a_record.dc_public.fqdn
}

output "dc_public_ip" {
  value = azurerm_public_ip.dc.ip_address
}

output "member_dns_name" {
  value = azurerm_dns_a_record.member_public[*].fqdn
}

output "member_public_ips" {
  value = azurerm_public_ip.member[*].ip_address
}
