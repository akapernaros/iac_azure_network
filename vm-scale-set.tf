# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set
resource azurerm_linux_virtual_machine_scale_set vmss-web {
  name = local.vmss-web-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location = var.region_name

  admin_username = "km-admin"
  sku = "Standard_D2s_v3"
  instances = 3

  network_interface {
    name = local.nic-web-name
    ip_configuration {
      name = local.ipc-web-name
      subnet_id = azurerm_subnet.snet1.id
    }
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer = "UbuntuServer"
    publisher = "Canonical"
    sku = "18.04-LTS"
    version = "latest"
  }
}