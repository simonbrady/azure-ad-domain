# See variables.tf for descriptions of these
ad_domain        = "ad"
admin_user       = "dcadmin"
admin_cidrs      = ["127.0.0.1/32"] # CHANGE ME
dc_image_sku     = "2022-datacenter"
dc_name          = "dc"
dc_size          = "Standard_D2_v4"
dns_domain_name  = "example.com" # CHANGE ME
dns_rg_name      = "dns-rg"
dns_verification = "MS=ms12345678"
location         = "Australia East"
member_count     = 1
member_image_sku = "2022-datacenter-smalldisk"
member_name      = "member"
member_size      = "Standard_D2_v4"
prefix           = "ad"
timezone         = "New Zealand Standard Time"
vnet_cidr        = "10.0.0.0/16"
