locals {
  agw-bap-name = "${local.agw-name}-bap"
  agw-bhs-name = "${local.agw-name}-bhs"
  agw-fep-http-name = "${local.agw-name}-fep-http"
  agw-httpl-name = "${local.agw-name}-httpl-http"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
resource azurerm_application_gateway agw {
  name = local.agw-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location = var.region_name

  backend_address_pool {
    name = local.agw-bap-name
  }
  backend_http_settings {
    name = local.agw-bhs-name
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
  }

  frontend_ip_configuration {
    name = "${local.agw-name}-feipc"
    public_ip_address_id = azurerm_public_ip.agw.id
  }

  frontend_port {
    name = local.agw-fep-http-name
    port = 80
  }

  gateway_ip_configuration {
    name = "agw-${var.region_name}-${var.project_name}-gwipc"
    subnet_id = azurerm_subnet.agw.id
  }

  http_listener {
    name = local.agw-httpl-name
    frontend_ip_configuration_name = "${local.agw-name}-feipc"
    frontend_port_name = local.agw-fep-http-name
    protocol = "Http"
  }

  request_routing_rule {
    name = "${local.agw-name}-rqrt-http"
    http_listener_name = local.agw-httpl-name
    rule_type = "Basic"

    backend_address_pool_name = local.agw-bap-name
    backend_http_settings_name = local.agw-bhs-name
  }

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
    capacity = 2
  }
}

resource "azurerm_public_ip" "agw" {
  name = local.pip-agw-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location = var.region_name

  allocation_method = "Static"
  sku = "Standard"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record
resource azurerm_dns_a_record agw {
  name = "www"
  resource_group_name = azurerm_resource_group.resourcegroup.name

  zone_name = azurerm_dns_zone.dnsz.name
  ttl = 300

  target_resource_id = azurerm_public_ip.agw.id
}