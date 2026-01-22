variable "token" {
  type        = string
  default = ""
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default = ""
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default = ""
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_user" {
  type        = string
  default     = "ubuntu"
}


variable "vm_user_nat" {
  type        = string
  default     = "ubuntu"
}

######## Задание №2 ############

variable "bucket_access_key" {
  default = ""
}

variable "bucket_secret_key" {
  default = ""

}
