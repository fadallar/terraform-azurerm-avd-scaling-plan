<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
# Azure Virtual Desktop Scaling Plan
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)

Module which can be used to creates an Azure Virtual Desktop Scaling plan and its diagnostic settings

## Examples

[01\_base\_testcase.md](./examples/01\_base\_testcase/README.md)
## Usage
Basic usage of this module is as follows:
```hcl
module "example" {
   source  = "<module-path>"

   # Required variables
   diag_log_analytics_workspace_id =
   friendly_name =
   host_pools =
   landing_zone_slug =
   location =
   location_short =
   resource_group_name =
   schedules =
   stack =

   # Optional variables
   custom_name = ""
   default_tags = {}
   description = ""
   diag_default_setting_name = "default"
   diag_log_categories = [
  "Autoscale"
]
   diag_metric_categories = []
   diag_retention_days = 30
   diag_storage_account_id = null
   exclusion_tag = null
   extra_tags = {}
   log_analytics_destination_type = "Dedicated"
   time_zone = "UTC"
   workload_info = ""
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >=1.8.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.41.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |
## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_virtual_desktop_scaling_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diag_log_analytics_workspace_id"></a> [diag\_log\_analytics\_workspace\_id](#input\_diag\_log\_analytics\_workspace\_id) | Log Analytics Workspace Id for logs and metrics diagnostics destination | `string` | n/a | yes |
| <a name="input_friendly_name"></a> [friendly\_name](#input\_friendly\_name) | A friendly name for the Virtual Desktop Workspace. | `string` | n/a | yes |
| <a name="input_host_pools"></a> [host\_pools](#input\_host\_pools) | hostpool\_id - The ID of the HostPool to assign the Scaling Plan to.<br>    scaling\_plan\_enabled - Specifies if the scaling plan is enabled or disabled for the HostPool. | <pre>list(object({<br>    hostpool_id          = string<br>    scaling_plan_enabled = optional(bool, true)<br>  }))</pre> | n/a | yes |
| <a name="input_landing_zone_slug"></a> [landing\_zone\_slug](#input\_landing\_zone\_slug) | Landing zone acronym,it will be used to generate the resource name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region to use. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Short string for Azure location. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group. | `string` | n/a | yes |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | n/a | <pre>list(object({<br>    name                                 = string<br>    days_of_week                         = list(string)<br>    ramp_up_start_time                   = string<br>    ramp_up_load_balancing_algorithm     = string<br>    ramp_up_minimum_hosts_percent        = optional(number)<br>    ramp_up_capacity_threshold_percent   = optional(number)<br>    peak_start_time                      = string<br>    peak_load_balancing_algorithm        = string<br>    ramp_down_start_time                 = string<br>    ramp_down_load_balancing_algorithm   = string<br>    ramp_down_minimum_hosts_percent      = number<br>    ramp_down_force_logoff_users         = string<br>    ramp_down_wait_time_minutes          = number<br>    ramp_down_notification_message       = string<br>    ramp_down_capacity_threshold_percent = number<br>    ramp_down_stop_hosts_when            = string<br>    off_peak_start_time                  = string<br>    off_peak_load_balancing_algorithm    = string<br>  }))</pre> | n/a | yes |
| <a name="input_stack"></a> [stack](#input\_stack) | Project stack name. | `string` | n/a | yes |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Custom resource name, it will overide the generated name if set | `string` | `""` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Base tagging | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the Virtual Desktop Host Pool. | `string` | `""` | no |
| <a name="input_diag_default_setting_name"></a> [diag\_default\_setting\_name](#input\_diag\_default\_setting\_name) | Name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| <a name="input_diag_log_categories"></a> [diag\_log\_categories](#input\_diag\_log\_categories) | List of categories to enable in the diagnostic settings | `list(string)` | <pre>[<br>  "Autoscale"<br>]</pre> | no |
| <a name="input_diag_metric_categories"></a> [diag\_metric\_categories](#input\_diag\_metric\_categories) | List of metric categories to enable in the diagnostic settings | `list(string)` | `[]` | no |
| <a name="input_diag_retention_days"></a> [diag\_retention\_days](#input\_diag\_retention\_days) | The number of days for which the Retention Policy should apply | `number` | `30` | no |
| <a name="input_diag_storage_account_id"></a> [diag\_storage\_account\_id](#input\_diag\_storage\_account\_id) | Storage Account Id for logs and metrics diagnostics destination | `string` | `null` | no |
| <a name="input_exclusion_tag"></a> [exclusion\_tag](#input\_exclusion\_tag) | The name of the tag associated with the VMs you want to exclude from autoscaling. | `string` | `null` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add. | `map(string)` | `{}` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | Possible values are AzureDiagnostics and Dedicated. Recommended value is Dedicated | `string` | `"Dedicated"` | no |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | n/a | `string` | `"UTC"` | no |
| <a name="input_workload_info"></a> [workload\_info](#input\_workload\_info) | Workload additional info to be used in the resource name | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_avd_scalingplan_id"></a> [avd\_scalingplan\_id](#output\_avd\_scalingplan\_id) | Virtual Desktop Scaling Plan resource id |
| <a name="output_avd_scalingplan_name"></a> [avd\_scalingplan\_name](#output\_avd\_scalingplan\_name) | Virtual Desktop Scaling Plan Name |
## Contact

Atos

to regenerate this `README.md` file run in pwsh, in current directory:

`docker run --rm -v "$($pwd.path):/data" cytopia/terraform-docs terraform-docs-012 -c tfdocs-config.yml ./module`

`docker run --rm --name pre -v "$($pwd.path):/lint" -w /lint ghcr.io/antonbabenko/pre-commit-terraform run -a`

`docker stop pre; docker rm pre; docker run --name pre -v "$($pwd.path):/lint" -w /lint ghcr.io/antonbabenko/pre-commit-terraform run -a`
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->