data azurerm_dns_zone parent {
  name = "azure.msgoat.eu"
}

resource azurerm_dns_zone dnsz {
  name = local.dns-zone-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

# Connect our dnsz to parent -> Add name server record to parent.
# https://en.wikipedia.org/wiki/List_of_DNS_record_types
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record
resource azurerm_dns_ns_record parentrecord {
  name = var.project_name

  # Refer to the parent's resource group instead of our own!
  resource_group_name = data.azurerm_dns_zone.parent.resource_group_name
  zone_name = data.azurerm_dns_zone.parent.name
  ttl = 3600

  # Add records for the name servers of our new zone.
  records = azurerm_dns_zone.dnsz.name_servers
}
