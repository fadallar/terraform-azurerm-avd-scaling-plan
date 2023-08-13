## This code ensures that the Azure Virtual Desktop service 
## principal has sufficient privilege to perform Host Pool Autoscaling
## It is not required if the service has already these privilege for the resource scope

resource "random_uuid" "this" {
}

resource "azurerm_role_definition" "this" {
  name        = "AVD-AutoScale"
  scope       = local.avd_role_definition_assignable_scope
  description = "AVD AutoScale Role"
  permissions {
    actions = [
      "Microsoft.Insights/eventtypes/values/read",
      "Microsoft.Compute/virtualMachines/deallocate/action",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Compute/virtualMachines/powerOff/action",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.DesktopVirtualization/hostpools/read",
      "Microsoft.DesktopVirtualization/hostpools/write",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/read",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/write",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/delete",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/read",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/sendMessage/action",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/read"
    ]
    not_actions = []
  }
  assignable_scopes = [
    local.avd_role_definition_assignable_scope,
  ]
}

data "azuread_service_principal" "this" {
  display_name = "Azure Virtual Desktop"
}

resource "azurerm_role_assignment" "this" {
  name                             = random_uuid.this.result
  scope                            = local.avd_role_definition_assignable_scope
  role_definition_id               = azurerm_role_definition.this.role_definition_resource_id
  principal_id                     = data.azuread_service_principal.this.id
  skip_service_principal_aad_check = true
}