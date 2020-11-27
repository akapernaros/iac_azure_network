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
      primary = true

      application_gateway_backend_address_pool_ids = [azurerm_application_gateway.agw.backend_address_pool[0].id]
    }

    // Docu says: If multiple network_interface blocks are specified, one must be set to primary.
    // But although we only have one network_interface block, we seem to be forced to mark this
    // explicitly as primary.
    primary = true
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

  // One of either admin_password or admin_ssh_key must be specified.
  // Temporary workaround: Use admin_password. Just to make deployment work at first.
  // Will have to be replaced by ssh key.
  disable_password_authentication = false
  admin_password = "The Wrath of Khan"

  custom_data = filebase64("${path.module}/resources/web-cloud-init.sh")

}