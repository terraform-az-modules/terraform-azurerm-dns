provider "azurerm" {
  features {}
}

locals {
  name        = "app"
  environment = "test"
  label_order = ["name", "environment", ]
}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azure"
  version     = "1.0.1"
  name        = local.name
  environment = local.environment
  label_order = local.label_order
  location    = "East US"
}

##-----------------------------------------------------------------------------
## DNS zone module call
## Below module will deploy public dns in azure.
##-----------------------------------------------------------------------------
module "dns_zone" {
  depends_on          = [module.resource_group]
  source              = "../.."
  environment         = local.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  dns_zone_names      = "cdexample.com"
  a_records = [{
    name    = "test"
    ttl     = 3600
    records = ["10.0.180.17", "10.0.180.18"]
    },
    {
      name    = "test2"
      ttl     = 3600
      records = ["10.0.180.17", "10.0.180.18"]
  }]

  cname_records = [{
    name   = "test1"
    ttl    = 3600
    record = "example.com"
  }]

  ns_records = [{
    name    = "test2"
    ttl     = 3600
    records = ["ns1.example.com.", "ns2.example.com."]
  }]

  aaaa_records = [{
    name    = "test-aaaa"
    ttl     = 300
    records = ["2001:db8::1:0:0:1"]
  }]

  caa_records = [{
    name = "test-caa"
    ttl  = 300
    records = [
      { flags = 0, tag = "issue", value = "example.com" },
      { flags = 0, tag = "issue", value = "example.net" },
      { flags = 0, tag = "issuewild", value = ";" },
      { flags = 0, tag = "iodef", value = "mailto:terraform@nonexisting.tld" }
    ]
  }]

  mx_records = [{
    name = "test-mx"
    ttl  = 300
    records = [
      { preference = 10, exchange = "mail1.contoso.com" },
      { preference = 20, exchange = "mail2.contoso.com" }
    ]
  }]

  ptr_records = [{
    name    = "test-ptr"
    ttl     = 300
    records = ["yourdomain.com"]
  }]

  srv_records = [{
    name = "test-srv"
    ttl  = 300
    records = [
      { priority = 1, weight = 5, port = 8080, target = "target1.contoso.com" }
    ]
  }]

  txt_records = [{
    name = "test-txt"
    ttl  = 300
    records = [
      "google-site-authenticator",
      "more site information here"
    ]
  }]


}
