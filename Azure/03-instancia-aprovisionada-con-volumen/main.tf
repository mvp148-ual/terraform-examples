resource "azurerm_resource_group" "tf-resource-group" {
  name     = var.azure-resource-group
  location = var.azure-location
}

resource "azurerm_virtual_network" "tf-net" {
  name                = var.azure-net-name
  location            = azurerm_resource_group.tf-resource-group.location
  resource_group_name = azurerm_resource_group.tf-resource-group.name
  address_space       = var.azure-address-space
  dns_servers         = var.azure-dns-servers
}

resource "azurerm_subnet" "tf-subnet" {
  name                 = var.azure-subnet-name
  resource_group_name  = azurerm_resource_group.tf-resource-group.name
  virtual_network_name = azurerm_virtual_network.tf-net.name
  address_prefixes     = var.azure-subnet-prefixes
}

resource "azurerm_network_security_group" "tf-nsg" {
  name                = "tf-nsg"
  location            = azurerm_resource_group.tf-resource-group.location
  resource_group_name = azurerm_resource_group.tf-resource-group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "tf-web-server-ip" {
  name                = "tf-web-server-ip"
  location            = azurerm_resource_group.tf-resource-group.location
  resource_group_name = azurerm_resource_group.tf-resource-group.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "tf-nic" {
  name                = "tf-nic"
  location            = azurerm_resource_group.tf-resource-group.location
  resource_group_name = azurerm_resource_group.tf-resource-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf-web-server-ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "tf-nic-nsg" {
  network_interface_id      = azurerm_network_interface.tf-nic.id
  network_security_group_id = azurerm_network_security_group.tf-nsg.id
}

resource "azurerm_linux_virtual_machine" "tf-web-server" {
  name                = "tf-web-server"
  resource_group_name = azurerm_resource_group.tf-resource-group.name
  location            = azurerm_resource_group.tf-resource-group.location
  size                = var.azure-vm-size
  admin_username      = var.azure-admin-username
  network_interface_ids = [
    azurerm_network_interface.tf-nic.id,
  ]


  admin_ssh_key {
    username   = var.azure-admin-username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.azure-storage-account-type
  }

  source_image_reference {
    publisher = var.azure-os-publisher
    offer     = var.azure-os-offer
    sku       = var.azure-os-sku
    version   = var.azure-os-version
  }

  user_data = base64encode(file("install-web-server.sh"))

  tags = {
    web_server = "tf-web-server"
  }
}

resource "azurerm_managed_disk" "tf-web-server-disk" {
  name                 = "tf-web-server-disk"
  location             = azurerm_resource_group.tf-resource-group.location
  resource_group_name  = azurerm_resource_group.tf-resource-group.name
  storage_account_type = var.azure-storage-account-type
  create_option        = "Empty"
  disk_size_gb         = 1
}

resource "azurerm_virtual_machine_data_disk_attachment" "tf-web-server-disk" {
  managed_disk_id    = azurerm_managed_disk.tf-web-server-disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.tf-web-server.id
  lun                = 10
  caching            = "ReadWrite"
}

# Mostrar la dirección IP pública del servidor web
output "tf-web-server-ip" {
  value      = azurerm_public_ip.tf-web-server-ip.ip_address
  depends_on = [azurerm_linux_virtual_machine.tf-web-server]
}
