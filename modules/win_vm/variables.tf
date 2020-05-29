variable "buildby" {
  description = "Name of the builder."
}

variable "environment" {
  description = "Prod,QA,STG,DEV,etc."
}

variable "location" {
  type        = "string"
  description = "Azure region for the environment."
}

variable "rsg" {
  type        = "string"
  description = "Resource Group to Create the VNET in"
}

variable "vnet" {
  description = "Name of the VNET you want to deploy the VM to"
}

variable "subnet" {
  description = "Name of the subnet you want to deploy the VM to"
}

variable "subnet_rsg" {
  description = "Name of the Resource Group the VNET is located in"
}

variable "accelerated_networking" {
  description = "Choose to enable accelerated networking.  Allowed Vaules are true and false. default to false"
}

variable "avset" {
  description = "The availabilty set where the virtual machines will reside."
}

variable "bootdiagsa" {
  description = "The storage account for boot diagnostics"
}

variable "bootdiagsa_rsg" {
  description = "The RSG where boot storage account resides"
}

variable "admin_password" {
  description = "password for all VMs"
}

variable "vm_name" {
  description = "Prefix for the VMs you are creating"
}

variable "vm_size" {
  description = "Size of the VM you want to create"
}

variable "vm_count" {
  description = "number of VMs to create"
}

variable "os_publisher" {
  description = "Image Publisher"
}

variable "os_offer" {
  description = "Image Offer"
}

variable "os_sku" {
  description = "Image Sku"
}

variable "vm_disk_sku" {
  description = "Type of disk to use. Either Standard_LRS or Premium_LRS."
}

variable "vm_timezone" {
  description = "Timezone to set the OS to using Microsoft Tiemzone Index values. See https://support.microsoft.com/en-gb/help/973627/microsoft-time-zone-index-values for values (2nd column)."
  default     = "UTC"
}
