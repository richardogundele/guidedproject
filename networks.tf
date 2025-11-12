# Network Security Groups


# Web Network Security Group
resource "azurerm_network_security_group" "web_nsg" {
    name                = "${var.prefix}-web-nsg"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "allow-http"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range         = "*"
        destination_port_range    = "80"
        source_address_prefix     = "*"
        destination_address_prefix = "*"
    }
}

# NSG for App Tier (Allows Traffic ONLY from Web Subnet)
resource "azurerm_network_security_group" "app_nsg" {
  name                = "${var.prefix}-app-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-From-Web-Tier"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = azurerm_subnet.web.address_prefixes[0] # Source is the Web Subnet CIDR
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "8080" # Assumed App Port
  }
}

# NSG for DB Tier (Allows Traffic ONLY from App Subnet)
resource "azurerm_network_security_group" "db_nsg" {
  name                = "${var.prefix}-db-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-From-App-Tier-SQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = azurerm_subnet.app.address_prefixes[0] # Source is the App Subnet CIDR
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "1433" # Standard SQL/DB port
  }
}

# 5. NSG to Subnet Associations

resource "azurerm_subnet_network_security_group_association" "web_assoc" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "app_assoc" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "db_assoc" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}
