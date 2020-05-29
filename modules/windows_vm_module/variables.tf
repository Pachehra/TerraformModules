
variable "nic_private_ip_address" {}
variable "vm_count" {}
variable "az_rg_infra" {
    description = "Azure infra resouce group name"
}
variable "az_rg" {
    description = "Azure app resouce group name"
}
variable "az_subnet" {
    description = "Azure app subnet name"
}
variable "az_vnet" {
    description = "Azure vnet name"
}
variable "az_storage_acc" {
    description = "Azure storage account id"
}
variable "vm_name" {}
variable "nic_private_ip_allocation_method" {}

variable "vm_size" {}
variable "admin_username" {}
variable "windows_admin_password" {}
variable "image_publisher" {}
variable "image_offer" {}
#variable "write_accelerator_enabled" {}
variable "image_sku" {}
variable "image_version" {}
variable "vm_os_disk_size" {}
variable "storage_account_type" {}
variable "extra_disk_size" {}
variable "extra_disk_size_wa" {}



