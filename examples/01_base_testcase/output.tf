output "avd_desktop_app_group_id" {
  description = "AVD Scaling Plan Id"
  value       = module.avdappgroup_desktop.avd_scalingplan_id
}

output "avd_rail_app_group_id" {
  description = "AVD Scaling Plan Name"
  value       = module.avdappgroup_rail.avd_scalingplan_name
}