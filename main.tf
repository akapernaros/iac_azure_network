provider "azurerm" {
  version = "~>2.36.0"
  features {}
}

locals {
  vnet-name = "vnet-${var.region_name}-${var.project_name}"
  rg-name = "rg-${var.region_name}-${var.project_name}"
  snetbast-name = "AzureBastionSubnet"
  snetapp-name = "snet-${var.region_name}-${var.project_name}-gateway"
  snet1-name = "snet-${var.region_name}-${var.project_name}-web"
  snet2-name = "snet-${var.region_name}-${var.project_name}-app"
  snet3-name = "snet-${var.region_name}-${var.project_name}-data"
  nsg-name = "nsg-${var.region_name}-${var.project_name}"
  nat-name = "nat-${var.region_name}-${var.project_name}"
  nat-name-pre = "nat-${var.region_name}-${var.project_name}-publicipprefix"
  pip-name = "pip-${var.region_name}-${var.project_name}"
  bast-name = "bast-${var.region_name}-${var.project_name}"

  dns-zone-name = "${var.project_name}.azure.msgoat.eu"
  vmss-web-name = "vmss-${var.region_name}-${var.project_name}-web"
  nic-web-name = "nic-${var.region_name}-${var.project_name}-web"
  ipc-web-name = "ipc-${var.region_name}-${var.project_name}-web"
  agw-name = "agw-${var.region_name}-${var.project_name}"
  pip-agw-name = "pip-${var.region_name}-${var.project_name}-agw"
}
