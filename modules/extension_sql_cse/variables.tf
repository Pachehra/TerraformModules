variable "rsg" {
  type        = "string"
  description = "Resource Group to create the VM extension in"
}

variable "location" {
  description = "Azure region for the environment."
}

variable "vm_name" {
  description = "Name of the VM you are creating the extension on"
  type        = "list"
}

variable "vm_count" {
  description = "Number of VMs"
}

variable "storage_account" {
  description = "Asset storage account"
}

variable "storage_account_key" {
  description = "Storage Account Key for asset storage account. Can be found at https://passwordsafe.corp.rackspace.com/projects/25979/credentials"
}
