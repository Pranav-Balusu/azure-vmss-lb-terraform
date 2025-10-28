#vmss autoscaling and monitoring 

#log analytics workspace
resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = "vmss-logs"
  location            = "azurerm_resource_group.rg.location"
  resource_group_name = "azurerm_resource_group.rg.name"
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#diagnosis for vmss

resource "azurerm_monitor_diagnostic_setting" "vmss_diagostics" {
  name                       = "vmss-dignostic"
  target_resource_id         = "azurerm_linux_virtual_machine_scale_set.vmss.id"
  log_analytics_workspace_id = "azurerm_log_analytics_workspace.log_workspace.id"

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

#autoscale based on cpu usage

resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = "vmss-autoscale"
  resource_group_name = "azurerm_resource_group.rg.name"
  location            = "azurerm_resource_group.rg.location"
  target_resource_id  = "azurerm_linux_virtual_machine_scale_set.vmss.id"
  enabled             = true

  profile {
    name = "auto-scale-profile"

    capacity {
      minimum = 2
      maximum = 5
      default = 2
    }

    #scale out when cpu>75%

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = "azurerm_linux_virtual_machine_scale_set.vmss.id"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }

    #scale in when CPU<25%

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = "azurerm_linux_virtual_machine_scale_set.vmss.id"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }
      scale_action {
        type      = "ChangeCount"
        direction = "Decrease"
        value     = 1
        cooldown  = "PT5M"
      }
    }
  }
}

#outputs

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.log_workspace.name
}

output "autoscale_setting_name" {
  value = azurerm_monitor_autoscale_setting.vmss_autoscale.name
}