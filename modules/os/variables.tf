variable "vm_os_simple" {
  default = ""
}

# Definition of the standard OS with "SimpleName" = "publisher,offer,sku"
variable "standard_os" {
  default = {
    "UbuntuServer"  = "Canonical,UbuntuServer,16.04-LTS"
    "WindowsServer2016" = "MicrosoftWindowsServer,WindowsServer,2016-Datacenter"
    "WindowsServer2016smalldisk" = "MicrosoftWindowsServer,WindowsServer,2016-Datacenter-smalldisk"
    "WindowsServer2012R2" = "MicrosoftWindowsServer,WindowsServer,2012-R2-Datacenter"
    "WindowsServer2012R2smalldisk" = "MicrosoftWindowsServer,WindowsServer,2012-R2-Datacenter-smalldisk"
    "RHEL"          = "RedHat,RHEL,7.3"
    "openSUSE-Leap" = "SUSE,openSUSE-Leap,42.2"
    "CentOS"        = "OpenLogic,CentOS,7.3"
    "CentOS7.5"     = "OpenLogic,CentOS,7.5"
    "Oracle7.5"     = "Oracle,Oracle-Linux,7.5"
    "Debian"        = "credativ,Debian,8"
    "CoreOS"        = "CoreOS,CoreOS,Stable"
    "SLES"          = "SUSE,SLES,12-SP2"
    "SQL2012SP3-WS2012R2-Standard" = "MicrosoftSQLServer,SQL2012SP3-WS2012R2,Standard"
    "SQL2012SP4-WS2012R2-Standard" = "MicrosoftSQLServer,SQL2012SP4-WS2012R2,Standard"
    "SQL2017-WS2016-Standard" = "MicrosoftSQLServer,SQL2017-WS2016,Standard"
  }
}
