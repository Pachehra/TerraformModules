resource "azurerm_virtual_machine_extension" "loc_env_vm_bginfo" {
  count                      = "${var.vm_count}"
  name                       = "BGInfo"
  location                   = "${var.location}"
  resource_group_name        = "${var.rsg}"
  virtual_machine_name       = "${element(var.vm_name, count.index)}"
  publisher                  = "Microsoft.Compute"
  type                       = "BGInfo"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = "True"
}
