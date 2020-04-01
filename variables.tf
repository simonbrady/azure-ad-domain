variable "ad_domain" {
  type        = string
  description = "Name of AD domain within DNS zone"
}

variable "admin_user" {
  type        = string
  description = "Name of local admin user"
}

variable "admin_cidrs" {
  type        = list(string)
  description = "CIDR ranges to allow RDP from"
}

variable "dc_image_sku" {
  type        = string
  description = "SKU for domain controller VM image"
}

variable "dc_image_version" {
  type        = string
  description = "Version of domain controller VM image"
}

variable "dc_name" {
  type        = string
  description = "Domain controller computer name"
}

variable "dc_size" {
  type        = string
  description = "Size of domain controller VM"
}

variable "dns_rg_name" {
  type        = string
  description = "Resource group containing DNS zone to create A record in"
}

variable "dns_verification" {
  type        = string
  description = "Verification text to prove ownership of custom domain"
}

variable "dns_domain_name" {
  type        = string
  description = "DNS zone to create domain under"
}

variable "location" {
  type        = string
  description = "Azure location to deploy to"
}

variable "member_count" {
  type        = number
  description = "Number of member servers to create"
}

variable "member_image_sku" {
  type        = string
  description = "SKU for member server VM image"
}

variable "member_image_version" {
  type        = string
  description = "Version of member server VM image"
}

variable "member_name" {
  type        = string
  description = "Member server computer name (numeric suffix will be added)"
}

variable "member_size" {
  type        = string
  description = "Size of member server VM"
}

variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
}

variable "timezone" {
  type        = string
  description = "Server time zone"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR range for vnet address space"
}
