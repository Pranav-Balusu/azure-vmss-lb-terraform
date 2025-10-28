#load balancer

#public ip for load balancer

resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = "azurerm_resource_group.rg.location"
  resource_group_name = "azurerm_resource_group.rg.name"
  allocation_method   = "Static"
  sku                 = "Standard"
}

#load balancer

resource "azurerm_lb" "lb" {
  name                = "demo-lb"
  location            = "azurerm_resource_group.rg.location"
  resource_group_name = "azurerm_resource_group.rg.name"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "lb-frontend"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

#backend pool

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name            = "lb-backend-pool"
  loadbalancer_id = "azurerm_lb.lb.id"
}

#health probe

resource "azurerm_lb_probe" "lb_probe" {
  name                = "http-probe"
  loadbalancer_id     = "azurerm_lb.lb.id"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

#load balancer rule

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "http-rule"
  loadbalancer_id                = "azurerm_lb.lb.id"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "lb-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id                       = "azurerm_lb_probe.lb_probe.id"

}


#outputs

output "load_balacer_ip" {
  value = azurerm_public_ip.lb_public_ip.ip_address
}

output "lb_name" {
  value = azurerm_lb.lb.name
}

output "lb_backend_pool_name" {
  value = azurerm_lb_backend_address_pool.lb_backend_pool.name
}
