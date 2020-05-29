output "vm_ids" {
  value = "${azurerm_virtual_machine.loc_env_vm.*.id}"
}

output "vm_names" {
  value = "${azurerm_virtual_machine.loc_env_vm.*.name}"
}

output "vm_passwords" {
  value = "${var.admin_password}"
}

output "vm_private_ips" {
  value = "${azurerm_network_interface.loc_env_vm_nic.*.private_ip_address}"
}

output "vm_nics" {
  value = "${azurerm_network_interface.loc_env_vm_nic.*.id}"
}

output "vm_rsg" {
  value = "${azurerm_virtual_machine.loc_env_vm.*.resource_group_name}"
}

output "vm_location" {
  value = "${azurerm_virtual_machine.loc_env_vm.*.location}"
}
