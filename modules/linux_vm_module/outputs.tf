# output "vm_private_ip" {
#   value = azurerm_network_interface.vm_nic.*.private_ip_address
# }

output "vm_name_private_ip" {
  value = "${
      formatlist(
        "%s:%s",
        azurerm_linux_virtual_machine.vm.*.name,
        azurerm_network_interface.vm_nic.*.private_ip_address
      )
    }"
}