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

<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
