output "resource_group_name" {
    description = "Name of the Resource Group"
    value       = azurerm_resource_group.rg.name
}

output "frontend_url" {
    description = "URL of the Frontend Application"
    value       = "https://${azurerm_linux_web_app.frontend.default_hostname}"
}

output "backend_url" {
    description = "URL of the Backend API"
    value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
}

output "web_subnet_id" {
    description = "Resource ID of the Web Subnet"
    value       = azurerm_subnet.web.id
}

output "app_subnet_id" {
    description = "Resource ID of the Application Subnet"
    value       = azurerm_subnet.app.id
}

output "db_subnet_id" {
    description = "Resource ID of the Database Subnet"
    value       = azurerm_subnet.db.id
}

output "app_insights_key" {
    description = "Application Insights Instrumentation Key"
    value       = azurerm_application_insights.main.instrumentation_key
    sensitive   = true
}