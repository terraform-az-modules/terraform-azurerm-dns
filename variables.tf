##-----------------------------------------------------------------------------
## Labels
##-----------------------------------------------------------------------------

variable "location" {
  type        = string
  default     = null
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "environment" {
  type        = string
  default     = null
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "managedby" {
  type        = string
  default     = "terraform-az-modules"
  description = "ManagedBy, eg 'terraform-az-modules'."
}

variable "label_order" {
  type        = list(string)
  default     = ["name", "environment", "location"]
  description = "The order of labels used to construct resource names or tags. If not specified, defaults to ['name', 'environment', 'location']."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azure-dns"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Specifies how the infrastructure/resource is deployed"
}

variable "extra_tags" {
  type        = map(string)
  default     = null
  description = "Variable to pass extra tags."
}

##-----------------------------------------------------------------------------
## Dns
##-----------------------------------------------------------------------------

variable "dns_zone_names" {
  type        = string
  default     = null
  description = "The public dns zone to be created for internal vnet resolution"

}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "The name of the resource group where the Azure DNS resides"
}

variable "enable" {
  type        = bool
  default     = true
  description = "Flag to control complete module creation."
}

variable "enable_public_dns" {
  type        = bool
  default     = true
  description = "Flag to control creation of public dns"
}

variable "a_records" {
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
  }))
  default     = []
  description = "List of a records to be added in azure dns zone."
}

variable "cname_records" {
  type = list(object({
    name   = string
    ttl    = number
    record = string
  }))
  default     = []
  description = "List of cname records"
}

variable "ns_records" {
  type = list(object({
    name    = string,      #(Required) The name of the DNS NS Record. Changing this forces a new resource to be created.
    ttl     = number,      # (Required) The Time To Live (TTL) of the DNS record in seconds.
    records = list(string) #(Required) A list of values that make up the NS record.
  }))
  default     = []
  description = "List of ns records"
}

variable "soa_record" {
  type        = list(object({}))
  default     = []
  description = "Customize details about the root block device of the instance. See Block Devices below for details."
}

variable "aaaa_records" {
  description = "List of AAAA records"
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "caa_records" {
  description = "List of CAA records"
  type = list(object({
    name = string
    ttl  = number
    records = list(object({
      flags = number
      tag   = string
      value = string
    }))
  }))
  default = []
}

variable "mx_records" {
  description = "List of MX records"
  type = list(object({
    name = string
    ttl  = number
    records = list(object({
      preference = number
      exchange   = string
    }))
  }))
  default = []
}

variable "ptr_records" {
  description = "List of PTR records"
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "srv_records" {
  description = "List of SRV records"
  type = list(object({
    name = string
    ttl  = number
    records = list(object({
      priority = number
      weight   = number
      port     = number
      target   = string
    }))
  }))
  default = []
}

variable "txt_records" {
  description = "List of TXT records"
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}
