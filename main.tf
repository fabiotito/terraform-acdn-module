#CDN Profile
resource "azurerm_cdn_profile" "acdn" {
  name                = "${local.resource_name}"
  resource_group_name = "${local.resource_group_name}"
  location            = "${local.location}"
  sku                 = "${var.acdn_sku}"
  tags                = "${merge(var.tags, local.tags)}"
}
#CDN Endpoint
resource "azurerm_cdn_endpoint" "ecdn" {
  name                          = "${local.resource_name_ecdn}"
  resource_group_name           = "${azurerm_cdn_profile.acdn.resource_group_name}"
  location                      = "${azurerm_cdn_profile.acdn.location}"
  profile_name                  = "${azurerm_cdn_profile.acdn.name}"
  is_http_allowed               = "${local.is_http_allowed}"
  is_https_allowed              = "${local.is_https_allowed}"
  querystring_caching_behaviour = "${local.querystring_caching_behaviour}"
  tags                          = "${merge(var.tags, local.tags)}"

  origin {
    name      = "${local.origin_name}"
    host_name = "${local.origin_host_name}"
  }
}

#CDN Endpoint Log
resource "azurerm_monitor_diagnostic_setting" "ecdn" {
  name                       = "logs"
  target_resource_id         = "${azurerm_cdn_endpoint.ecdn.id}"
  log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.lgan.id}"

  log {
    category = "CoreAnalytics"
    enabled  = true
    retention_policy {
      enabled = true
    }
  }
}
