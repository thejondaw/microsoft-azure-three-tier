# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-project.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet #1 for Azure Firewall
resource "azurerm_subnet" "subnet_1" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.azure-project.name
  address_prefixes     = ["10.0.101.0/24"]
}

# Subnet #2 for Internet Gateway
resource "azurerm_subnet" "subnet_2" {
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.azure-project.name
  address_prefixes     = ["10.0.102.0/24"]
}

# Subnet #3 for NIC / NSG / Scale Set
resource "azurerm_subnet" "subnet_3" {
  name                 = "subnet_3"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.azure-project.name
  address_prefixes     = ["10.0.103.0/24"]
}

# ---------------------------------------------------------------------------

# Virtual Network Interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-project.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_3.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-project.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-ICMP"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group & Subnet #3 Association
resource "azurerm_subnet_network_security_group_association" "nsg-sub" {
  subnet_id                 = azurerm_subnet.subnet_3.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# ---------------------------------------------------------------------------

# Public IP for Firewall
resource "azurerm_public_ip" "firewall" {
  name                = "Public-IP-Firewall"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-project.name
  allocation_method   = "Static"
  domain_name_label   = azurerm_resource_group.azure-project.name
}

resource "azurerm_firewall" "example" {
  name                = "firewall"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-project.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_1.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_firewall_network_rule_collection" "example" {
  name                = "testcollection"
  azure_firewall_name = azurerm_firewall.example.name
  resource_group_name = azurerm_resource_group.azure-project.name
  priority            = 100
  action              = "Allow"

  rule {
    name              = "enable-icmp"
    source_addresses  = ["10.0.0.0/16"]
    destination_ports = ["53"]
    protocols         = ["ICMP"]
  }
}

# ---------------------------------------------------------------------------

# Public IP for Internet Gateway
resource "azurerm_public_ip" "igw_ip" {
  name                = "IGW-IP"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-project.name
  allocation_method   = "Dynamic"
}

# Internet Gateway
resource "azurerm_virtual_network_gateway" "igw" {
  name                = "IGW"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-project.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.igw_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_2.id
  }
}