variable "ubuntu_version" {
  type = string
  default = "24.04.1"
}

variable "hostname" {
  type = string
}

variable "cloud_init_include_files" {
  type = list(string)
  default = []
}
