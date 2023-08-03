variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region to use."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
  validation {
    condition     = var.stack == "" || can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.stack))
    error_message = "Invalid variable: ${var.stack}. Variable name must start with a lowercase letter, end with an alphanumeric lowercase character, and contain only lowercase letters, digits, or a dash (-)."
  }
}

variable "friendly_name" {
  type        = string
  description = "A friendly name for the Virtual Desktop Workspace."
  ### TO-DO add Validation Block
}

variable "description" {
  type        = string
  description = "A description for the Virtual Desktop Host Pool."
  default     = ""
  ### TO-DO add Validation Block
}

variable "host_pools" {
  type = list(object({
    hostpool_id          = string
    scaling_plan_enabled = optional(bool, true)
  }))
  description = <<DESC
    hostpool_id - The ID of the HostPool to assign the Scaling Plan to.
    scaling_plan_enabled - Specifies if the scaling plan is enabled or disabled for the HostPool.
  DESC
}

variable "time_zone" {
  type = string
  #description = <<DESC
  #Specifies the Time Zone which should be used by the Scaling Plan for time based events
  #The possible values are described here https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/
  #DESC
  default = "UTC"
}

variable "exclusion_tag" {
  description = "The name of the tag associated with the VMs you want to exclude from autoscaling."
  type        = string
  default     = null
}

variable "schedules" {
  #description = <<DESC
  #days_of_week - A list of Days of the Week on which this schedule will be used. Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, and Sunday
  #name - The name of the schedule.
  #off_peak_load_balancing_algorithm - The load Balancing Algorithm to use during Off-Peak Hours. Possible values are DepthFirst and BreadthFirst.
  #off_peak_start_time - The time at which Off-Peak scaling will begin. This is also the end-time for the Ramp-Down period. The time must be specified in HH:MM format.
  #peak_load_balancing_algorithm - The load Balancing Algorithm to use during Peak Hours. Possible values are DepthFirst and BreadthFirst.
  #peak_start_time - The time at which Peak scaling will begin. This is also the end-time for the Ramp-Up period. The time must be specified in HH:MM format.
  #ramp_down_capacity_threshold_percent - This is the value in percentage of used host pool capacity that will be considered to evaluate whether to turn on/off virtual machines during the ramp-down and off-peak hours. For example, if capacity threshold is specified as 60% and your total host pool capacity is 100 sessions, autoscale will turn on additional session hosts once the host pool exceeds a load of 60 sessions.
  #ramp_down_force_logoff_users - Whether users will be forced to log-off session hosts once the ramp_down_wait_time_minutes value has been exceeded during the Ramp-Down period. Possible
  #ramp_down_load_balancing_algorithm - The load Balancing Algorithm to use during the Ramp-Down period. Possible values are DepthFirst and BreadthFirst.
  #ramp_down_minimum_hosts_percent - The minimum percentage of session host virtual machines that you would like to get to for ramp-down and off-peak hours. For example, if Minimum percentage of hosts is specified as 10% and total number of session hosts in your host pool is 10, autoscale will ensure a minimum of 1 session host is available to take user connections.
  #ramp_down_notification_message - The notification message to send to users during Ramp-Down period when they are required to log-off.
  #ramp_down_start_time - The time at which Ramp-Down scaling will begin. This is also the end-time for the Ramp-Up period. The time must be specified in HH:MM format.
  #ramp_down_stop_hosts_when - Controls Session Host shutdown behaviour during Ramp-Down period. Session Hosts can either be shutdown when all sessions on the Session Host have ended, or when there are no Active sessions left on the Session Host. Possible values are ZeroSessions and ZeroActiveSessions.
  #ramp_down_wait_time_minutes - The number of minutes during Ramp-Down period that autoscale will wait after setting the session host VMs to drain mode, notifying any currently signed in users to save their work before forcing the users to logoff. Once all user sessions on the session host VM have been logged off, Autoscale will shut down the VM.
  #ramp_up_load_balancing_algorithm - The load Balancing Algorithm to use during the Ramp-Up period. Possible values are DepthFirst and BreadthFirst.
  #ramp_up_start_time - The time at which Ramp-Up scaling will begin. This is also the end-time for the Ramp-Up period. The time must be specified in HH:MM format.
  #ramp_up_capacity_threshold_percent - This is the value of percentage of used host pool capacity that will be considered to evaluate whether to turn on/off virtual machines during the ramp-up and peak hours. For example, if capacity threshold is specified as 60% and your total host pool capacity is 100 sessions, autoscale will turn on additional session hosts once the host pool exceeds a load of 60 sessions.
  #ramp_up_minimum_hosts_percent - Specifies the minimum percentage of session host virtual machines to start during ramp-up for peak hours. For example, if Minimum percentage of hosts is specified as 10% and total number of session hosts in your host pool is 10, autoscale will ensure a minimum of 1 session host is available to take user connections.
  #DESC
  type = list(object({
    name                                 = string
    days_of_week                         = list(string)
    ramp_up_start_time                   = string
    ramp_up_load_balancing_algorithm     = string
    ramp_up_minimum_hosts_percent        = optional(number)
    ramp_up_capacity_threshold_percent   = optional(number)
    peak_start_time                      = string
    peak_load_balancing_algorithm        = string
    ramp_down_start_time                 = string
    ramp_down_load_balancing_algorithm   = string
    ramp_down_minimum_hosts_percent      = number
    ramp_down_force_logoff_users         = string
    ramp_down_wait_time_minutes          = number
    ramp_down_notification_message       = string
    ramp_down_capacity_threshold_percent = number
    ramp_down_stop_hosts_when            = string
    off_peak_start_time                  = string
    off_peak_load_balancing_algorithm    = string
  }))
}