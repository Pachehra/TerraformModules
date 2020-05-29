# availabilty set
resource "azurerm_availability_set" "loc_env_vm_avset" {
  name                = "${var.vm_avset}"
  location            = "${var.location}"
  resource_group_name = "${var.rsg}"
  managed             = "true"

  tags {
    Environment = "${var.environment}"
    BuildBy     = "${var.buildby}"
    BuildDate   = "${replace(substr(timestamp(), 0, 10), "-", "")}"
  }
}
