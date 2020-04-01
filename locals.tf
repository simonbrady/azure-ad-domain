locals {
  # Resource name prefixes for domain controller and member servers
  dc_prefix     = "${var.prefix}-dc"
  member_prefix = "${var.prefix}-member"
}
