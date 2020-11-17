resource "azurerm_public_ip" "ngw" {
  allocation_method = "Static"
  location = var.region_name
  name = local.pip-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  sku ="Standard"
}

resource "azurerm_bastion_host" "bastion" {
  location = var.region_name
  name = local.bast-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  ip_configuration {
    name = "configuration"
    subnet_id = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.ngw.id
  }
}
