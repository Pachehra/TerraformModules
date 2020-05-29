resource "azurerm_virtual_machine_extension" "loc_env_vm_iis_cse" {
  count                = "${var.vm_count}"
  name                 = "customizeOS"
  location             = "${var.location}"
  resource_group_name  = "${var.rsg}"
  virtual_machine_name = "${element(var.vm_name, count.index)}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<-BASE_SETTINGS
 {
    "fileUris": [
              "https://raxazurescripts.blob.core.windows.net/scripts/customizeIISOS.ps1"
      ]
 }
 BASE_SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
 {
   "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File customizeIISOS.ps1",
    "storageAccountName": "${var.storage_account}",
    "storageAccountKey": "${var.storage_account_key}"
 }
 PROTECTED_SETTINGS
}
