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
