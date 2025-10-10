##-----------------------------------------------------------------------------
## Tagging Module – Applies standard tags to all resources
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/labels/azure"
  version         = "1.0.0"
  name            = var.dns_zone_names
  location        = var.location
  environment     = var.environment
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

##-----------------------------------------------------------------------------
## Below resource will deploy public DNS zone in azure.
##-----------------------------------------------------------------------------
resource "azurerm_dns_zone" "main" {
  count               = var.enable && var.enable_public_dns ? 1 : 0
  name                = var.dns_zone_names
  resource_group_name = var.resource_group_name
  tags                = module.labels.tags
  dynamic "soa_record" {
    for_each = var.soa_record
    content {
      email        = lookup(soa_record.value, "email", null)
      expire_time  = lookup(soa_record.value, "expire_time", null)
      minimum_ttl  = lookup(soa_record.value, "minimum_ttl", null)
      refresh_time = lookup(soa_record.value, "refresh_time", null)
      retry_time   = lookup(soa_record.value, "retry_time", null)
      ttl          = lookup(soa_record.value, "ttl", null)
    }
  }
}

##-----------------------------------------------------------------------------
## Below resource will add a_record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_a_record" "records_a" {
  for_each            = var.enable && var.enable_public_dns ? { for record in var.a_records : record.name => record } : {}
  name                = lookup(each.value, "name", null) # Required
  zone_name           = azurerm_dns_zone.main[0].name
  resource_group_name = var.resource_group_name
  ttl                 = lookup(each.value, "ttl", null)                # Required
  records             = lookup(each.value, "records", null)            # Optional(Conflicts with target_resource_id) {Either records OR target_resource_id must be specified, but not both.}
  target_resource_id  = lookup(each.value, "target_resource_id", null) # Optional(Conflicts with records) {Either records OR target_resource_id must be specified, but not both.}
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## Below resource will add cname_record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_cname_record" "records_cname" {
  for_each            = var.enable && var.enable_public_dns ? { for record in var.cname_records : record.name => record } : {}
  name                = lookup(each.value, "name", null) # Required
  zone_name           = azurerm_dns_zone.main[0].name
  resource_group_name = var.resource_group_name
  ttl                 = lookup(each.value, "ttl", null)                # Required
  record              = lookup(each.value, "record", null)             # Optional(Conflicts with target_resource_id) {Either record OR target_resource_id must be specified, but not both.}
  target_resource_id  = lookup(each.value, "target_resource_id", null) # Optional(Conflicts with record) {Either records OR target_resource_id must be specified, but not both.}
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## Below resource will add ns_record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_ns_record" "records_ns" {
  for_each            = var.enable && var.enable_public_dns ? { for record in var.ns_records : record.name => record } : {}
  name                = each.value.name
  zone_name           = azurerm_dns_zone.main[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## Below resource will add AAAA Record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_aaaa_record" "records_aaaa" {
  for_each            = var.enable && var.enable_public_dns ? { for record in var.aaaa_records : record.name => record } : {}
  name                = each.value.name
  zone_name           = azurerm_dns_zone.main[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## Below resource will add CAA Record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_caa_record" "records_caa" {
  for_each            = var.enable && var.enable_public_dns ? { for record in var.caa_records : record.name => record } : {}
  name                = each.value.name
  zone_name           = azurerm_dns_zone.main[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records
    content {
      flags = record.value.flags
      tag   = record.value.tag
      value = record.value.value
    }
  }

  tags = module.labels.tags
}

##-----------------------------------------------------------------------------
## Below resource will add MX Record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_mx_record" "records_mx" {
  for_each            = var.enable && var.enable_public_dns ? { for record in var.mx_records : record.name => record } : {}
  name                = each.value.name
  zone_name           = azurerm_dns_zone.main[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records
    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }

  tags = module.labels.tags
}

##-----------------------------------------------------------------------------
## Below resource will add PTR Record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_ptr_record" "records_ptr" {
  for_each            = var.enable && var.enable_public_dns ? { for record in var.ptr_records : record.name => record } : {}
  name                = each.value.name
  zone_name           = azurerm_dns_zone.main[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = module.labels.tags
}


##-----------------------------------------------------------------------------
## Below resource will add # SRV Record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_srv_record" "records_srv" {
  for_each            = var.enable && var.enable_public_dns ? { for record in var.srv_records : record.name => record } : {}
  name                = each.value.name
  zone_name           = azurerm_dns_zone.main[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records
    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }

  tags = module.labels.tags
}

##-----------------------------------------------------------------------------
## Below resource will add # TXT Record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_txt_record" "records_txt" {
  for_each            = var.enable && var.enable_public_dns ? { for record in var.txt_records : record.name => record } : {}
  name                = each.value.name
  zone_name           = azurerm_dns_zone.main[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records
    content {
      value = record.value
    }
  }

  tags = module.labels.tags
}
