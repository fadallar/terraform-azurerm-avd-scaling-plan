# Add Checkov skips here, if required.
resource "azurerm_virtual_desktop_scaling_plan" "this" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = var.description
  friendly_name       = var.friendly_name
  time_zone           = var.time_zone
  dynamic "schedule" {
    for_each = var.schedules != null ? var.schedules : []
    content {
      name                                 = schedule.value.name
      days_of_week                         = schedule.value.days_of_week
      ramp_up_start_time                   = schedule.value.ramp_up_start_time
      ramp_up_load_balancing_algorithm     = schedule.value.ramp_up_load_balancing_algorithm
      ramp_up_minimum_hosts_percent        = schedule.value.ramp_up_minimum_hosts_percent
      ramp_up_capacity_threshold_percent   = schedule.value.ramp_up_capacity_threshold_percent
      peak_start_time                      = schedule.value.peak_start_time
      peak_load_balancing_algorithm        = schedule.value.peak_load_balancing_algorithm
      ramp_down_start_time                 = schedule.value.ramp_down_start_time
      ramp_down_load_balancing_algorithm   = schedule.value.ramp_down_load_balancing_algorithm
      ramp_down_minimum_hosts_percent      = schedule.value.ramp_down_minimum_hosts_percent
      ramp_down_force_logoff_users         = schedule.value.ramp_down_force_logoff_users
      ramp_down_wait_time_minutes          = schedule.value.ramp_down_wait_time_minutes
      ramp_down_notification_message       = schedule.value.ramp_down_notification_message
      ramp_down_capacity_threshold_percent = schedule.value.ramp_down_capacity_threshold_percent
      ramp_down_stop_hosts_when            = schedule.value.ramp_down_stop_hosts_when
      off_peak_start_time                  = schedule.value.off_peak_start_time
      off_peak_load_balancing_algorithm    = schedule.value.off_peak_load_balancing_algorithm
    }
  }
  dynamic "host_pool" {
    for_each = var.host_pools != null ? var.host_pools : []
    content {
      hostpool_id          = host_pool.value.hostpool_id
      scaling_plan_enabled = host_pool.value.scaling_plan_enabled
    }

  }
  depends_on = [azurerm_role_assignment.this]
}