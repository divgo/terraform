
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resourcegroup_name}"

  ip_configuration {
    name                          = "${var.vm_name}-ipconfig"
    subnet_id                     = "/subscriptions/-------------------/resourceGroups/--------/providers/Microsoft.Network/virtualNetworks/-------/subnets/---"
    private_ip_address_allocation = "dynamic"
  }
}

# The virtual machine
resource "azurerm_virtual_machine" "virtual_machine" {
  name                = "${var.vm_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resourcegroup_name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_D2s_v3"
  license_type          = "Windows_Server"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    os_type           = "windows"
    disk_size_gb      = "256"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${var.vm_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
    }
  }

  tags {
    role       = "test_server"
    created_by = "terraform"
  }
}
resource "azurerm_virtual_machine_extension" "dsc" {
    name = "DevOpsDSC"
    location = "${var.location}"
    resource_group_name = "${var.resourcegroup_name}"
    virtual_machine_name = "${var.vm_name}"
    publisher = "Microsoft.Powershell"
    type = "DSC"
    type_handler_version = "2.73"
    depends_on = ["azurerm_virtual_machine.virtual_machine"]
    settings = <<SETTINGS
        {
            "ModulesUrl":"",
            "SasToken":"",
            "WmfVersion": "latest",
            "Privacy": {
                "DataCollection": ""
            },
            "ConfigurationFunction":""
        }
    SETTINGS
}

resource "azurerm_virtual_machine_extension" "register_for_dsc" {
    name = "register_for_dsc"
    location = "${var.location}"
    resource_group_name = "${var.resourcegroup_name}"
    virtual_machine_name = "${var.vm_name}"
    publisher = "Microsoft.Compute"
    type = "CustomScriptExtension"
    type_handler_version = "1.8"
    depends_on = ["azurerm_virtual_machine_extension.dsc"]

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://[storage_account_name].blob.core.windows.net/scripts/DscMetaConfigs.ps1",
          "https://[storage_account_name].blob.core.windows.net/scripts/Execute_DscScripts.ps1"
        ]
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -File ./Execute_DscScripts.ps1 ${var.dsc_key} ${var.dsc_endpoint}",
      "storageAccountName": "[storage_account_name]",
      "storageAccountKey": "[storage_account_access_key]"
    }
PROTECTED_SETTINGS
}