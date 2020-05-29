output "avset_id" {
  value = "${azurerm_availability_set.loc_env_vm_avset.id}"
}

output "avset_name" {
  value = "${azurerm_availability_set.loc_env_vm_avset.name}"
}
