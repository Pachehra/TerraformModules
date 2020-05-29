#Code to build out complete VM.
# See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html fro syntax.

# Data source for the subnet that already exists
data "azurerm_subnet" "loc_env_vm_subnet" {
  name                 = "${var.subnet}"
  virtual_network_name = "${var.vnet}"
  resource_group_name  = "${var.subnet_rsg}"
}

# Data source for the avset that already exists
data "azurerm_availability_set" "loc_env_vm_avset" {
  name                = "${var.avset}"
  resource_group_name = "${var.rsg}"
}

#Data source for storage account that already exists
data "azurerm_storage_account" "loc_env_vm_sa" {
  name                = "${var.bootdiagsa}"
  resource_group_name = "${var.bootdiagsa_rsg}"
}

# NIC
resource "azurerm_network_interface" "loc_env_vm_nic" {
  count                         = "${var.vm_count}"
  name                          = "${var.vm_name}${count.index+1}-nic"
  location                      = "${var.location}"
  resource_group_name           = "${var.rsg}"
  enable_accelerated_networking = "${var.accelerated_networking}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.loc_env_vm_subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }

  tags {
    Environment = "${var.environment}"
    BuildBy     = "${var.buildby}"
    BuildDate   = "${replace(substr(timestamp(), 0, 10), "-", "")}"
  }
}

#VM
resource "azurerm_virtual_machine" "loc_env_vm" {
  count                 = "${var.vm_count}"
  name                  = "${var.vm_name}${count.index+1}"
  location              = "${var.location}"
  resource_group_name   = "${var.rsg}"
  network_interface_ids = ["${element(azurerm_network_interface.loc_env_vm_nic.*.id, count.index)}"]
  availability_set_id   = "${data.azurerm_availability_set.loc_env_vm_avset.id}"
  vm_size               = "${var.vm_size}"

  # Uncomment the line below to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment the line below to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.os_publisher}"
    offer     = "${var.os_offer}"
    sku       = "${var.os_sku}"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}${count.index+1}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.vm_disk_sku}"
  }

  os_profile {
    computer_name  = "${var.vm_name}${count.index+1}"
    admin_username = "${lower(var.vm_name)}${count.index+1}-adm"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = "true"
    timezone           = "${var.vm_timezone}"
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${data.azurerm_storage_account.loc_env_vm_sa.primary_blob_endpoint}"
  }

  tags {
    Environment = "${var.environment}"
    BuildBy     = "${var.buildby}"
    BuildDate   = "${replace(substr(timestamp(), 0, 10), "-", "")}"
  }
}
