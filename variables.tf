##Public Global variables
#variable sp_aut_id {}
#variable sp_aut_pwd {}
#variable azure_tenant {}
#variable "azure_subscription" {}
variable cod_app {}     # abcd
variable cod_env {}     # d/c/p
variable cod_loc {}     # eu2/eu1/cu1
variable correlativo {} # [01]...[99]

##Public ACDN module variables
variable acdn_sku {} # standard_verizon/premium_verizon

##Private ACDN/ECDN module variables (Infra + LBS)
locals {
  #Default infra ACDN
  cod_svc             = "acdn" #Cod. Servicio
  cod_loc             = "${lower(var.cod_loc != null ? var.cod_loc : "eu2")}"
  location            = "${lookup(var.map_location, local.cod_loc)}"
  correlativo         = "${var.correlativo != null ? var.correlativo : local.correlativo_inicial}"
  correlativo_inicial = "01"
  cod_resource_group  = "rsgr"
  resource_name       = "${lower("${local.cod_svc}${local.cod_loc}${var.cod_app}${var.cod_env}${local.correlativo}")}"
  resource_group_name = "${upper("${local.cod_resource_group}${local.cod_loc}${var.cod_app}${var.cod_env}${local.correlativo_inicial}")}"

  #Default infra ECDN
  cod_svc_ecdn                      = "ecdn" #Cod. Servicio
  resource_name_ecdn                = "${lower("${local.cod_svc_ecdn}${local.cod_loc}${var.cod_app}${var.cod_env}${local.correlativo_inicial}")}"
  cod_lgan                          = "lgan" #Codigo de servicio de Log Analytics
  cod_env_infra                     = "f"    #Codigo de ambiente del grupo de infraestructura
  log_analytics_name                = "${lower("${local.cod_lgan}${local.cod_loc}${var.cod_app}${var.cod_env}${local.correlativo_inicial}")}"
  log_analytics_resource_group_name = "${upper("${local.cod_resource_group}${local.cod_loc}${var.cod_app}${local.cod_env_infra}${local.correlativo_inicial}")}"

  #Default resource ECDN
  origin_name                   = "originName"
  origin_host_name              = "www.example.com"
  querystring_caching_behaviour = "${lower(var.acdn_sku) == "standard_verizon" ? "IgnoreQueryString" : "NotSet"}"

  #Default LBS ECDN
  is_http_allowed  = false
  is_https_allowed = true
}
variable "map_location" {
  type = map(string)
  default = {
    eu1 = "eastus"
    eu2 = "eastus2"
    cu1 = "centralus"
  }
}

#Tags
variable tags {
  default = {
    provisionedFrom = "Acdn-Module"
  }
}
locals {
  tags = {
    provisionedBy = "Terraform"
    operation     = "IBM"
    codApp        = "${upper(var.cod_app)}"
    environment   = "${lower(var.cod_env) == "d" ? "DESA" : lower(var.cod_env) == "c" ? "CERT" : "PROD"}"
  }
}

##Contexto
data "azurerm_subscription" "current" {}

##Logs
data "azurerm_log_analytics_workspace" "lgan" {
  name                = "${local.log_analytics_name}"
  resource_group_name = "${local.log_analytics_resource_group_name}"
}
