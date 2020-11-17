resource "azurerm_resource_group" "resourcegroup" {
  name     = local.rg-name
  location = var.region_name
}

resource "azurerm_network_security_group" "security_group" {
  name = local.nsg-name
  location = var.region_name
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_virtual_network" "virtual-network" {
  address_space = ["10.0.0.0/16"]
  location = var.region_name
  name = local.vnet-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "bastion" {
  address_prefixes = ["10.0.1.0/24"]
  name = local.snetbast-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
}

resource "azurerm_subnet" "agw" {
  address_prefixes = ["10.0.2.0/24"]
  name = local.snetapp-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
}

resource "azurerm_subnet" "snet1" {
  address_prefixes = ["10.0.3.0/24"]
  name = local.snet1-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
}

resource "azurerm_subnet_network_security_group_association" "snet1_nsg_link" {
  subnet_id                 = azurerm_subnet.snet1.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}

resource "azurerm_subnet" "snet2" {
  address_prefixes = ["10.0.4.0/24"]
  name = local.snet2-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
}

resource "azurerm_subnet_network_security_group_association" "snet2_nsg_link" {
  subnet_id                 = azurerm_subnet.snet2.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}

resource "azurerm_subnet" "snet3" {
  address_prefixes = ["10.0.5.0/24"]
  name = local.snet3-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
}

resource "azurerm_subnet_network_security_group_association" "snet3_nsg_link" {
  subnet_id                 = azurerm_subnet.snet3.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}

resource "azurerm_public_ip" "ngw" {
  allocation_method = "Static"
  location = var.region_name
  name = local.pip-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  sku ="Standard"
}

resource "azurerm_public_ip_prefix" "ngw" {
  name                = local.nat-name-pre
  location            = var.region_name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  sku ="Standard"
  prefix_length = 31
}

resource "azurerm_nat_gateway" "ngw" {
  name                    = local.nat-name
  location                = var.region_name
  resource_group_name     = azurerm_resource_group.resourcegroup.name
  public_ip_prefix_ids    = [ azurerm_public_ip_prefix.ngw.id ]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_subnet_nat_gateway_association" "snetlink1" {
  subnet_id      = azurerm_subnet.snet1.id
  nat_gateway_id = azurerm_nat_gateway.ngw.id
}

resource "azurerm_subnet_nat_gateway_association" "snetlink2" {
  subnet_id      = azurerm_subnet.snet2.id
  nat_gateway_id = azurerm_nat_gateway.ngw.id
}

resource "azurerm_subnet_nat_gateway_association" "snetlink3" {
  subnet_id      = azurerm_subnet.snet3.id
  nat_gateway_id = azurerm_nat_gateway.ngw.id
}