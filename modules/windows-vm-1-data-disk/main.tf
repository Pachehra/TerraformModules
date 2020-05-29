module "os" {
  source       = "../os"
  vm_os_simple = "${var.vm_os_simple}"
}

#boot diag storage account
resource "random_id" "vm_sa" {
  byte_length = 8
}

resource "azurerm_storage_account" "vm_sa" {
  count                    = "${var.boot_diagnostics == "true" ? 1 : 0}"
  name                     = "bootdiag${lower(random_id.vm_sa.hex)}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "${element(split("_", var.boot_diagnostics_sa_type),0)}"
  account_replication_type = "${element(split("_", var.boot_diagnostics_sa_type),1)}"
  tags                     = "${var.tags}"
}

resource "azurerm_availability_set" "vm" {
  //count                        = "${length(var.av_names)}"
  //name                         = "${var.av_names[count.index]}"
  name = "${var.av_names[count.index]}"

  resource_group_name          = "${var.resource_group_name}"
  location                     = "${var.location}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  managed                      = true
  tags                         = "${var.tags}"
}

resource "azurerm_public_ip" "vm" {
  count               = "${var.public_ip_count}"
  name                = "${var.vm_hostname[count.index]}-pip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  allocation_method = "${var.public_ip_address_allocation}"

  #domain_name_label            = "${element(var.public_ip_dns, count.index)}"
}

resource "azurerm_network_interface" "vm" {
  count                         = "${var.instance_count}"
  name                          = "${var.vm_hostname[count.index]}-nic"
  resource_group_name           = "${var.resource_group_name}"
  location                      = "${var.location}"
  enable_accelerated_networking = "${var.enable_accelerated_networking}"

  #network_security_group_id = "${var.nsg_id}"

  ip_configuration {
    name                          = "${var.vm_hostname[count.index]}-ipconfig"
    subnet_id                     = "${var.vnet_subnet_id}"
    private_ip_address_allocation = "${var.private_ip_address_allocation}"
    private_ip_address            = "${var.private_ip_address_allocation == "Static" ? var.private_ip_address[count.index] : "" }"

    public_ip_address_id = "${length(azurerm_public_ip.vm.*.id) > 0 ? element(concat(azurerm_public_ip.vm.*.id, list("")), count.index) : ""}"
  }
}

resource "azurerm_virtual_machine" "vm-windows-with-1-datadisk" {
  count                            = "${var.instance_count}"
  name                             = "${var.vm_hostname[count.index]}"
  location                         = "${var.location}"
  resource_group_name              = "${var.resource_group_name}"
  availability_set_id              = "${azurerm_availability_set.vm.id}"
  vm_size                          = "${var.vm_size}"
  network_interface_ids            = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  delete_os_disk_on_termination    = "${var.delete_os_disk_on_termination}"
  delete_data_disks_on_termination = "${var.delete_data_disks_on_termination }"

  storage_image_reference {
    id        = "${var.vm_os_id}"
    publisher = "${var.vm_os_id == "" ? coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher) : ""}"
    offer     = "${var.vm_os_id == "" ? coalesce(var.vm_os_offer, module.os.calculated_value_os_offer) : ""}"
    sku       = "${var.vm_os_id == "" ? coalesce(var.vm_os_sku, module.os.calculated_value_os_sku) : ""}"
    version   = "${var.vm_os_id == "" ? var.vm_os_version : ""}"
  }

  storage_os_disk {
    name              = "${var.vm_hostname[count.index]}-os"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "${var.storage_account_type}"
  }

  storage_data_disk {
    name              = "${var.vm_hostname[count.index]}-data0"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "${var.data_disk_0_size_gb}"
    managed_disk_type = "${var.data_sa_type}"
  }

  os_profile {
    computer_name  = "${var.vm_hostname[count.index]}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  tags = "${var.tags}"

  os_profile_windows_config {
    provision_vm_agent = "True"
  }

  boot_diagnostics {
    enabled     = "${var.boot_diagnostics}"
    storage_uri = "${var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.vm_sa.*.primary_blob_endpoint) : "" }"
  }
}

resource "azurerm_virtual_machine_extension" "bginfo" {
  name                       = "BGInfo"
  location                   = "${var.location}"
  resource_group_name        = "${var.resource_group_name}"
  virtual_machine_name       = "${var.vm_hostname[count.index]}"
  publisher                  = "Microsoft.Compute"
  type                       = "BGInfo"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = "True"

  depends_on = [
    "azurerm_virtual_machine.vm-windows-with-1-datadisk",
  ]

  
}

// vm diagnostics storage account
resource "random_id" "vm_diag" {
  byte_length = 8
}

resource "azurerm_storage_account" "vm_diag" {
  count                     = "${var.vm_diagnostics == "true" ? 1 : 0}"
  name                      = "vmdiag0${lower(replace(var.vm_hostname[count.index],"-",""))}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"
  account_tier              = "${element(split("_", var.vm_diagnostics_sa_type),0)}"
  account_replication_type  = "${element(split("_", var.vm_diagnostics_sa_type),1)}"
  tags                      = "${var.tags}"
  account_kind              = "${var.vm_diagnostics_account_kind}"
  access_tier               = "${var.vm_diagnostics_access_tier}"
  enable_https_traffic_only = "${var.vm_diagnostics_https_only}"
}

/*
resource "azurerm_virtual_machine_extension" "windows_script" {
  name                       = "WindowsCustomScripts"
  location                   = "${var.location}"
  resource_group_name        = "${var.resource_group_name}"
  virtual_machine_name       = "${var.vm_hostname[count.index]}"
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "WindowsCustomScripts"
  type_handler_version       = "2.0"
  settings = <<SETTINGS
    {
        "commandToExecute": "NetSh Advfirewall set allprofiles state off"
    }
SETTINGS
  depends_on = [
    "azurerm_virtual_machine.vm-windows-with-1-datadisk",
  ]
}



// 


resource "azurerm_virtual_machine_extension" "vmdiagnostics" {
  name                       = "VMDiagnosticsSettings"
  location                   = "${var.location}"
  resource_group_name        = "${var.resource_group_name}"
  virtual_machine_name       = "${var.vm_hostname[count.index]}"
  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = "True"

  settings = <<SETTINGS
  {
          "xmlCfg": "[base64(variables('wadcfgx'))]",
          "StorageAccount": "${azurerm_storage_account.vm_diag.name}"
        }
 SETTINGS

  # ${azurerm_storage_account.vm_diag.id}
  protected_settings = <<PROTECTED
  {
          "storageAccountName": "${azurerm_storage_account.vm_diag.name}",
          "storageAccountKey": "[listKeys(${azurerm_storage_account.vm_diag.id}),'2015-05-01-preview').key1]",
          "storageAccountEndPoint": "https://core.windows.net/"
        
  }
  PROTECTED

  depends_on = [
    "azurerm_storage_account.vm_diag",
    "azurerm_virtual_machine.vm-windows-with-1-datadisk",
  ]
}
*/