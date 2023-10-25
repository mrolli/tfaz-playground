variable "tenant_id" {
  type    = string
  default = "d400387a-212f-43ea-ac7f-77aa12d7977e" # == UniBE
}

variable "subscription_id" {
  type    = string
  default = "9671b6ad-4877-4a42-9609-9eaf88283097" # == UniBE - IDSYS - DEV - 021-14
}

variable "host_os" {
  type = string
}

variable "project-tags" {
  type = map(string)
  default = {
    environment = "dev"
    division    = "id"
    subDivision = "sys"
  }
}
