# AVD Scaling Plan - Base test case

This is an example for setting-up a an Azure Virtual Desktop Scaling Plan

This test case:

- Sets the different Azure Region representation (location, location_short, location_cli ...) --> module "regions"
- Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
- Creates the following module dependencies
  - Resource Group
  - Log Analytics workspace
- Creates an Azure Virtual Desktop Hostpool
- Creates a Role definition and assign it to the Azure Virtual Desktop service principal
- Creates a AVD Scaling plan

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Main.tf file content

Please replace the modules source and version with your relevant information

```hcl
# Test case local inputs
locals {
  stack             = "avdappgroup"
  landing_zone_slug = "sbx"
  location          = "westeurope"

  # 
  extra_tags = {
    tag1 = "FirstTag",
    tag2 = "SecondTag"
  }

  # base tagging values
  environment     = "sbx"
  application     = "terra-module"
  cost_center     = "CCT"
  change          = "CHG666"
  owner           = "Fabrice"
  spoc            = "Fabrice"
  tlp_colour      = "WHITE"
  cia_rating      = "C1I1A1"
  technical_owner = "Fabrice"

  # AVD Host Pool

  avd_host_friendly_name                   = "my friendly name"
  avd_host_description                     = "my description"
  avd_host_private_endpoint                = false
  avd_host_custom_rdp_properties           = "enablerdsaadauth:i:1;audiocapturemode:i:1"
  avd_host_scheduled_agent_updates_enabled = true
  avd_host_schedule_agent_updates_schedules = [
    {
      "day_of_week" : "Monday"
      "hour_of_day" : 23
    },
    {
      "day_of_week" : "Friday"
      "hour_of_day" : 21

    }
  ]
  # AVD App Scale Plan
  avd_role_definition_assignable_scope = module.resource_group.resource_group_id // Please adapt the scope accordingly
  avd_scale_plan_friendly_name = "My friendly name"
  avd_scale_plan_description   = "My description"
  avd_scale_plan_schedules = [{
    name                                 = "Weekdays"
    days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    ramp_up_start_time                   = "05:00"
    ramp_up_load_balancing_algorithm     = "BreadthFirst"
    ramp_up_minimum_hosts_percent        = 20
    ramp_up_capacity_threshold_percent   = 10
    peak_start_time                      = "09:00"
    peak_load_balancing_algorithm        = "BreadthFirst"
    ramp_down_start_time                 = "19:00"
    ramp_down_load_balancing_algorithm   = "DepthFirst"
    ramp_down_minimum_hosts_percent      = 10
    ramp_down_force_logoff_users         = false
    ramp_down_wait_time_minutes          = 45
    ramp_down_notification_message       = "Please log off in the next 45 minutes..."
    ramp_down_capacity_threshold_percent = 5
    ramp_down_stop_hosts_when            = "ZeroSessions"
    off_peak_start_time                  = "22:00"
    off_peak_load_balancing_algorithm    = "DepthFirst"
    }
  ]
  avd_scale_plan_host_pools = [{
    hostpool_id          = module.avdhostpool_desktop.avd_host_pool_id
    scaling_plan_enabled = true
  }]
}

module "regions" {
  source       = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module?ref=master"
  azure_region = local.location
}

module "base_tagging" {
  source          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module?ref=master"
  environment     = local.environment
  application     = local.application
  cost_center     = local.cost_center
  change          = local.change
  owner           = local.owner
  spoc            = local.spoc
  tlp_colour      = local.tlp_colour
  cia_rating      = local.cia_rating
  technical_owner = local.technical_owner
}

module "resource_group" {
  source            = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module?ref=master"
  stack             = local.stack
  landing_zone_slug = local.landing_zone_slug
  default_tags      = module.base_tagging.base_tags
  location          = module.regions.location
  location_short    = module.regions.location_short
}

module "diag_log_analytics_workspace" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-loganalyticsworkspace//module?ref=master"

  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags

}

# TO-DO  change avdhostpool source to main branch when mergerd
module "avdhostpool_desktop" {
  source                          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-avdhostpool//module?ref=develop"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  extra_tags                      = local.extra_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id
  workload_info                   = "desktop"

  # Module Parameters

  friendly_name                    = local.avd_host_friendly_name
  description                      = local.avd_host_description
  enable_private_endpoint          = local.avd_host_private_endpoint
  custom_rdp_properties            = local.avd_host_custom_rdp_properties
  scheduled_agent_updates_enabled  = local.avd_host_scheduled_agent_updates_enabled
  schedule_agent_updates_schedules = local.avd_host_schedule_agent_updates_schedules
  preferred_app_group_type         = "Desktop"
}

# Please replace the source with git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-avdscaleplan//module?ref=<Master or Tag reference>
module "avdscaleplan" {
  source                          = "../../module"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  extra_tags                      = local.extra_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  # Module Parameters
  friendly_name = local.avd_scale_plan_friendly_name
  description   = local.avd_scale_plan_description
  schedules     = local.avd_scale_plan_schedules
  host_pools    = local.avd_scale_plan_host_pools

  depends_on = [azurerm_role_assignment.this] // !!! ONLY applicable if AVD does not already have the required privileges

}
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_avdhostpool_desktop"></a> [avdhostpool\_desktop](#module\_avdhostpool\_desktop) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-avdhostpool//module | develop |
| <a name="module_avdscaleplan"></a> [avdscaleplan](#module\_avdscaleplan) | ../../module | n/a |
| <a name="module_base_tagging"></a> [base\_tagging](#module\_base\_tagging) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module | master |
| <a name="module_diag_log_analytics_workspace"></a> [diag\_log\_analytics\_workspace](#module\_diag\_log\_analytics\_workspace) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-loganalyticsworkspace//module | master |
| <a name="module_regions"></a> [regions](#module\_regions) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module | master |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module | master |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [random_uuid.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_avd_scale_name"></a> [avd\_scale\_name](#output\_avd\_scale\_name) | AVD Scaling Plan Name |
| <a name="output_avd_scale_plan_id"></a> [avd\_scale\_plan\_id](#output\_avd\_scale\_plan\_id) | AVD Scaling Plan Id |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
