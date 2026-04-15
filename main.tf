terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "2f15128a-2c84-44cd-bb27-6d7b415d83a1"
}

# Resource Group
resource "azurerm_resource_group" "lab" {
  name     = "terraform-lab-rg"
  location = "centralus"
}

# Virtual Network
resource "azurerm_virtual_network" "lab" {
  name                = "terraform-lab-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
}

# Subnet
resource "azurerm_subnet" "lab" {
  name                 = "terraform-lab-subnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "lab" {
  name                = "terraform-lab-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_virtual_network.lab,
    azurerm_subnet.lab
  ]
}

# VM Windows Server
resource "azurerm_windows_virtual_machine" "lab" {
  name                = "tf-lab-vm"
  computer_name       = "tf-lab-vm"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminaires"
  admin_password      = "Terraform@2026!"

  network_interface_ids = [
    azurerm_network_interface.lab.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}