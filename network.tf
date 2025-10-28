#Networking Resources

resource "azurerm_virtual_network" "vent" {
  name                = "vmss-lb-vnet"
  resource_group_name = "azurerm_resource_group.rgn.name"
  location            = "azurerm_resource_group.rg.location"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "vmss-lb-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vent.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "vms-lb-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = "azurerm_network_security_group.rg.name"

  security_rule  {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = "azurerm_subnet.subnet1.id"
  network_security_group_id = "azurerm_network_security_group.nsg.id"
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vent.name
}

output "subnet_name" {
  value = azurerm_subnet.subnet1.name
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg.name
}

