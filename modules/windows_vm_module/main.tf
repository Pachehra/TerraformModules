
data "azurerm_resource_group" "infra" {
	name = var.az_rg_infra
}

data "azurerm_resource_group" "rg" {
	name = var.az_rg
}

data "azurerm_subnet" "subnet" {
	name                 = var.az_subnet
	virtual_network_name = var.az_vnet
	resource_group_name  = data.azurerm_resource_group.infra.name
}

data "azurerm_storage_account" "diag" {
    name                     = var.az_storage_acc
	resource_group_name      = data.azurerm_resource_group.infra.name
}

resource "azurerm_network_interface" "vm_nic" {
	count               = var.vm_count
	name                = "${var.vm_name}${count.index +1}-nic1"
	location            = data.azurerm_resource_group.rg.location
	resource_group_name = data.azurerm_resource_group.rg.name

	ip_configuration {
		name                          = "${var.vm_name}${count.index +1}-ip1"
		subnet_id                     = data.azurerm_subnet.subnet.id
		private_ip_address_allocation = var.nic_private_ip_allocation_method
    private_ip_address         = element(var.nic_private_ip_address, count.index)
	}

	tags = {
		BuildBy = "Terraform"
	}
}

resource "azurerm_windows_virtual_machine" "vm" {
  count 							= var.vm_count
	name                            = "${var.vm_name}${count.index +1}"
	size                            = var.vm_size
	location                        = data.azurerm_resource_group.rg.location
	resource_group_name             = data.azurerm_resource_group.rg.name
  	network_interface_ids           = [azurerm_network_interface.vm_nic[count.index].id]
  	admin_username                  = var.admin_username
  	admin_password                  = var.windows_admin_password
  	# disable_password_authentication = false

	source_image_reference {
		publisher = var.image_publisher
		offer     = var.image_offer
		sku       = var.image_sku
		version   = var.image_version
	}

	os_disk {
		caching              = "ReadWrite"
		storage_account_type =  var.storage_account_type
		disk_size_gb = var.vm_os_disk_size
	}

  	boot_diagnostics {
  		storage_account_uri = data.azurerm_storage_account.diag.primary_blob_endpoint
  	}

	tags = {
		BuildBy = "Terraform"
	}
}
resource "azurerm_managed_disk" "vm_disk" {
  count = element(var.extra_disk_size,1) == null ? 0: length(var.extra_disk_size)
 name                 = "${var.vm_name}${count.index +1}-extradisk-${count.index +1}"
 location             = data.azurerm_resource_group.rg.location
 resource_group_name  = data.azurerm_resource_group.rg.name
 storage_account_type = var.storage_account_type
 create_option        = "Empty"
 disk_size_gb         = element(var.extra_disk_size,1) == null ? null: element(var.extra_disk_size,count.index)
 tags = {
    BuildBy = "Terraform"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_disk_attach" {
  count = element(var.extra_disk_size,1) == null ? 0: length(var.extra_disk_size)
 managed_disk_id    = azurerm_managed_disk.vm_disk[count.index].id
 virtual_machine_id = azurerm_windows_virtual_machine.vm[0].id
 lun                = count.index +1
 caching            =  "ReadWrite"
}
resource "azurerm_managed_disk" "vm_disk_wa" {
  count = element(var.extra_disk_size_wa,1) == null ? 0: length(var.extra_disk_size_wa)
 name                 = "${var.vm_name}${count.index +1}-extradisk-wa-${count.index +1}"
 location             = data.azurerm_resource_group.rg.location
 resource_group_name  = data.azurerm_resource_group.rg.name
 storage_account_type = var.storage_account_type
 create_option        = "Empty"
 disk_size_gb         = element(var.extra_disk_size_wa,1) == null ? null: element(var.extra_disk_size_wa,count.index)
 tags = {
    BuildBy = "Terraform"
  }
}
resource "azurerm_virtual_machine_data_disk_attachment" "vm_disk_attach_wa" {
  count = element(var.extra_disk_size_wa,1) == null ? 0: length(var.extra_disk_size_wa)
 managed_disk_id    = azurerm_managed_disk.vm_disk_wa[count.index].id
 virtual_machine_id = azurerm_windows_virtual_machine.vm[0].id
 lun                = count.index + length(var.extra_disk_size) +1
 caching            =   "None"
 write_accelerator_enabled = true
}