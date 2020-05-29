variable "rsg" {
  type        = "string"
  description = "Resource Group to create the disk in"
}

variable "location" {
  description = "Azure region for the environment."
}

variable "vm_name" {
  description = "Name for the disk you are creating"
  type        = "list"
}

variable "vm_count" {
  description = "Number of disks to create"
}

variable "storage_account" {
  description = "Asset storage account"
}

variable "storage_account_key" {
  description = "Storage Account Key for asset storage account. Can be found at https://passwordsafe.corp.rackspace.com/projects/25979/credentials"
}
