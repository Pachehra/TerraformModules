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
  description = "Resource Group to create the AVSET in"
}

variable "vm_avset" {
  description = "Name for the AVSET you are creating"
}
