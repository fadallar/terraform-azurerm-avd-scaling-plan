output "avd_scalingplan_id" {
  description = "Virtual Desktop Scaling Plan resource id"
  value       = azurerm_virtual_desktop_scaling_plan.this.id
}

output "avd_scalingplan_name" {
  description = "Virtual Desktop Scaling Plan Name"
  value       = azurerm_virtual_desktop_scaling_plan.this.name
}