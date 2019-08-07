output "applicationCode" {
  value = "${var.cod_app}"
}
output "environment" {
  value = "${local.tags.environment}"
}
output "subscription" {
  value = "${data.azurerm_subscription.current.display_name}/${data.azurerm_subscription.current.subscription_id}"
}
output "resourceName" {
  value = "${azurerm_cdn_profile.acdn.name}"
}
output "endPointName" {
  value = "${azurerm_cdn_endpoint.ecdn.name}"
}
output "resourceGroup" {
  value = "${azurerm_cdn_profile.acdn.resource_group_name}"
}
output "flavor" {
  value = "${azurerm_cdn_profile.acdn.sku}"
}
