# Active Directory in Azure

A simple [Terraform](https://www.terraform.io/) configuration to deploy a standalone
Active Directory domain in Azure. By default the code creates a Windows Server 2022
domain controller and a single 2022 member server in their own virtual network, with
public IPs for RDP access from the CIDR range(s) you whitelist.

This isn't intended as a production-ready AD deployment (and seriously, why would you
do that in Azure?) but it's useful to simulate an on-prem environment if you want to
play with tools like
[Entra Connect](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/whatis-azure-ad-connect).

## Deployment

Environment-specifc settings are in [terraform.tfvars](terraform.tfvars). At a minimum
you'll need to change `admin_cidrs` and `dns_domain_name` (see below for more about DNS).
Once you've done this, you can [install Terraform](https://developer.hashicorp.com/terraform/install)
if needed (any 1.x release should be fine) then deploy from the command line:

```
terraform init
terraform apply
```

The code can create multiple member servers in parallel depending on the value of the
`member_count` variable. Server names will be `member01`, `member02`, etc.

## Authentication

The code generates a random admin password which is available as an
[output](https://developer.hashicorp.com/terraform/language/values/outputs) once deployment
is complete. This password is used for the local administrator account (named according
to the `admin_user` input variable) on all the servers, so after the DC is promoted
it will also be the domain admin password. By default you can log on as `AD\dcadmin`
with this password, or `dcadmin@ad.example.com` (or whatever you've set `ad_domain`
and `dns_domain_name` to).

## DNS

At a minimum the `dns_domain_name` variable is used to construct the fully-qualified
AD domain name. If you have an existing public DNS zone in Azure, the code will also
create DNS `A` records for the servers' public IPs and a `TXT` record for
[Entra custom domain verification](https://learn.microsoft.com/en-us/entra/fundamentals/add-custom-domain).

If you don't have a public DNS zone you can comment out the resources in
[dns.tf](dns.tf) and the DNS-related outputs in [outputs.tf](outputs.tf),
although you'll still need to set `dns_domain_name` for AD itself.
