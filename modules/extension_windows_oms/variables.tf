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

variable "workspace_id" {
  description = "Workspace ID of OMS workspace the VM should join"
}

variable "workspace_key" {
  description = "The key of the OMS workspace the VM should join"
}
