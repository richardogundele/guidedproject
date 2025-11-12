variable "prefix" {
    description = "A prefix used for all resource names"
    type        = string
    default     = "devops-3tier"
}

variable "location" {
    description = "The azure region to deploy resources"
    type        = string
    default     = "South Central US"
}

variable "resource_group_name" {
    description  =  "Name of the Resource Group"
    type         =  string
    #default      =  "rg-devops-3tier"
    default      =  "1-6ef4a69a-playground-sandbox"
}

variable "vnet_cidr" {
    description    = "CIDR block for the Virtual Network"
    type           = list(string)
    default        = ["10.0.0.0/16"]
}

variable "subnet_cidrs" {
    description = "CIDR blocks for the three subnets (Web, App, DB)"
    type        = map(string)
    default  = {
        web = "10.0.1.0/24"
        app = "10.0.2.0/24"
        db  = "10.0.3.0/24"
    }
}

variable "app_service_sku" {
    description = "App Service Plan SKU (B1, B2, B3 for dev, P1V2+ for production)"
    type        = string
    default     = "B2"
}

variable "database_connection_string" {
    description = "Connection string for the database (SQLite for now)"
    type        = string
    default     = "sqlite:///tasktracker.db"
    sensitive   = true
}