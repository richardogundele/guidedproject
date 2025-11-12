# Generate random suffix for unique app names
resource "random_string" "app_suffix" {
  length  = 5
  special = false
  upper   = false
}


resource "azurerm_service_plan" "main" {
  name                = "${var.prefix}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.app_service_sku

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_linux_web_app" "frontend" {
  name                = "${var.prefix}-frontend-${random_string.app_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
        node_version = "22-lts"
    }

    cors {
        allowed_origins = ["*"]
        support_credentials = false
    }
  }
    app_settings = {
        "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
        "NODE_ENV"                            = "Production"
        "BACKEND_URL"                        = "https://${azurerm_linux_web_app.backend.default_hostname}"
    }
    https_only = true

    depends_on = [azurerm_application_insights.main]

    tags = {
        Environment = "Production"
    }
}

resource "azurerm_linux_web_app" "backend" {
  name                = "${var.prefix}-backend-${random_string.app_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
        python_version = "3.11"
    }

    cors {
        allowed_origins = ["*"]
        support_credentials = false
    }
  }
    app_settings = {
        "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
        "ENVIRONMENT"                         = "Production"
    }
    https_only = true

    depends_on = [azurerm_application_insights.main]

    tags = {
        Environment = "Production"
    }
}

#Application insights

resource "azurerm_application_insights" "main" {
    name                = "${var.prefix}-appinsights"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    application_type    = "web"

    tags = {
        Environment = "Production"
    }
}