# See variables.tf for descriptions of these
ad_domain            = "ad"
admin_user           = "dcadmin"
admin_cidrs          = ["123.45.67.89/32"] # CHANGE ME
dc_image_sku         = "2019-Datacenter"
dc_image_version     = "latest"
dc_name              = "dc"
dc_size              = "Standard_D2_v3"
dns_domain_name      = "example.com" # CHANGE ME
dns_rg_name          = "dns-rg"
dns_verification     = "MS=ms12345678"
location             = "Australia East"
member_count         = 1
member_image_sku     = "2019-Datacenter-smalldisk"
member_image_version = "latest"
member_name          = "member"
member_size          = "Standard_D2_v3"
prefix               = "ad"
timezone             = "New Zealand Standard Time"
vnet_cidr            = "10.0.0.0/16"
