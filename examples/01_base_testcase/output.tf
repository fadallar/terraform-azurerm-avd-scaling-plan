output "avd_desktop_app_group_id" {
  description = "AVD Scaling Plan Id"
  value       = module.avdscaleplan.avd_scalingplan_id
}

output "avd_rail_app_group_id" {
  description = "AVD Scaling Plan Name"
  value       = module.avdscaleplan.avd_scalingplan_name
}