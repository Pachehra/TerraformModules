output "vm_private_ips" {
  value = "${azurerm_network_interface.vm.*.private_ip_address}"
}

output "vm_public_ips" {
  value = "${azurerm_public_ip.vm.*.ip_address}"
}

output "storage_id" {
  value = "${azurerm_storage_account.vm_diag.*.id}"
}
/*
output "vm_id" {
  value = "${azurerm_virtual_machine.vm-windows-with-1-datadisk.id}"
}
*/