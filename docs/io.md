## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| a\_records | List of a records to be added in azure dns zone. | <pre>list(object({<br>    name    = string<br>    ttl     = number<br>    records = list(string)<br>  }))</pre> | `[]` | no |
| aaaa\_records | List of AAAA records | <pre>list(object({<br>    name    = string<br>    ttl     = number<br>    records = list(string)<br>  }))</pre> | `[]` | no |
| caa\_records | List of CAA records | <pre>list(object({<br>    name = string<br>    ttl  = number<br>    records = list(object({<br>      flags = number<br>      tag   = string<br>      value = string<br>    }))<br>  }))</pre> | `[]` | no |
| cname\_records | List of cname records | <pre>list(object({<br>    name   = string<br>    ttl    = number<br>    record = string<br>  }))</pre> | `[]` | no |
| deployment\_mode | Specifies how the infrastructure/resource is deployed | `string` | `"terraform"` | no |
| dns\_zone\_names | The public dns zone to be created for internal vnet resolution | `string` | `null` | no |
| enable | Flag to control complete module creation. | `bool` | `true` | no |
| enable\_public\_dns | Flag to control creation of public dns | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `null` | no |
| extra\_tags | Variable to pass extra tags. | `map(string)` | `null` | no |
| label\_order | The order of labels used to construct resource names or tags. If not specified, defaults to ['name', 'environment', 'location']. | `list(string)` | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no |
| location | The location/region where the virtual network is created. Changing this forces a new resource to be created. | `string` | `null` | no |
| managedby | ManagedBy, eg 'terraform-az-modules'. | `string` | `"terraform-az-modules"` | no |
| mx\_records | List of MX records | <pre>list(object({<br>    name = string<br>    ttl  = number<br>    records = list(object({<br>      preference = number<br>      exchange   = string<br>    }))<br>  }))</pre> | `[]` | no |
| ns\_records | List of ns records | <pre>list(object({<br>    name    = string,      #(Required) The name of the DNS NS Record. Changing this forces a new resource to be created.<br>    ttl     = number,      # (Required) The Time To Live (TTL) of the DNS record in seconds.<br>    records = list(string) #(Required) A list of values that make up the NS record.<br>  }))</pre> | `[]` | no |
| ptr\_records | List of PTR records | <pre>list(object({<br>    name    = string<br>    ttl     = number<br>    records = list(string)<br>  }))</pre> | `[]` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/terraform-az-modules/terraform-azure-dns"` | no |
| resource\_group\_name | The name of the resource group where the Azure DNS resides | `string` | `""` | no |
| soa\_record | Customize details about the root block device of the instance. See Block Devices below for details. | `list(object({}))` | `[]` | no |
| srv\_records | List of SRV records | <pre>list(object({<br>    name = string<br>    ttl  = number<br>    records = list(object({<br>      priority = number<br>      weight   = number<br>      port     = number<br>      target   = string<br>    }))<br>  }))</pre> | `[]` | no |
| txt\_records | List of TXT records | <pre>list(object({<br>    name    = string<br>    ttl     = number<br>    records = list(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns\_a\_record\_fqdn | The FQDN of the DNS A Record. |
| dns\_a\_record\_id | The DNS A Record ID. |
| dns\_cname\_record\_fqdn | The FQDN of the DNS CNAME Record. |
| dns\_cname\_record\_id | The DNS CNAME Record ID. |
| dns\_ns\_record\_fqdn | The FQDN of the DNS NS Record. |
| dns\_ns\_record\_id | The DNS NS Record ID. |
| dns\_zone\_id | The DNS Zone ID. |
| dns\_zone\_max\_number\_of\_record\_sets | Maximum number of Records in the zone. Defaults to 1000. |
| dns\_zone\_name\_servers | A list of values that make up the NS record for the zone. |
| dns\_zone\_number\_of\_record\_sets | The number of records already in the zone. |

