resource "azurerm_virtual_machine_extension" "loc_env_vm_oms" {
  count                      = "${var.vm_count}"
  name                       = "OMSExtension"
  location                   = "${var.location}"
  resource_group_name        = "${var.rsg}"
  virtual_machine_name       = "${element(var.vm_name, count.index)}"
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = "True"

  settings = <<-BASE_SETTINGS
 {
   "workspaceId" : "${var.workspace_id}"
 }
 BASE_SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
 {
   "workspaceKey" : "${var.workspace_key}"
 }
 PROTECTED_SETTINGS
}
