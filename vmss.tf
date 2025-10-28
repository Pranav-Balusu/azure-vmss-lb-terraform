#virtual machine scale set

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "demo-vmss"
  location            = "azurerm_resource_group.rg.name"
  resource_group_name = "azurerm_resource_group.rg.name"
  sku                 = "Standard_B1s"
  instances           = 2
  admin_username      = "azureuser"

  source_image_reference {
    publisher = "Canonical"
    offer     = "001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("$path.module/id_rsa.pub")
  }
  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "vmss-ipconfig"
      subnet_id                              = azurerm_subnet.subnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
      primary                                = true
    }
  }

  upgrade_mode = "Manual"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    environment = "Demo"
    Project     = "Terraform-VMSS"
  }
}